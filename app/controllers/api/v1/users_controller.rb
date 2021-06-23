class Api::V1::UsersController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token, except: [:create, :forgot_password, :facebook_auth]
  before_action :set_user, only: [:user_event_reviews, :get_bank_info, :payout, :total_earning, :recent_payouts, :add_stripe_token, :get_user_events, :show, :update, :destroy, :update_password, :update_user_skills, :get_user_services, :get_user_availed_services, :add_working_days, :get_unreviewed_events, :contact_as, :notifications, :update_notification, :fetch_notifications]
  before_action :check_user_with_email, only: [:facebook_auth]
  before_action :check_fb_user, only: [:create]
  before_action :check_user_skill, only: [:update_user_skills]

  # GET /users
  def index
    # @users = User.all
    @users = params[:search_for].present? ? User.user_search_condition(params[:search_for]) : User.confirmed
    render json: @users, current_user_id: params[:user_id]
  end

  # GET /users/1
  def show
    visit = @user.visits.order("created_at desc").limit(1).first
    if (visit.present? && (visit.visitor_id == params[:user_id].to_i))
      visit.destroy
    end
    @user.visits.create(visitor: current_user) if @user.id != current_user.id
    render json: @user, include: [:endorsements, :skill, :sub_skill], current_user_id: params[:user_id]
  end

  def visitors
    @users = current_user.visitors.where('visits.created_at > ?', 10.days.ago).order("created_at desc").limit(10)
    render json: @users, current_user_id: params[:user_id]
  end

  # POST /users
  def create
    unless @user
      @user = User.new(user_params)
      # debugger
    end
    pass = params[:user][:password]
    @user.password=@user.password_confirmation=pass
    if @user.save
      @user.setup_devices(params[:PushToken],params[:platform]) if params[:PushToken].present?
      render json: @user, include: [:endorsements, :skill, :sub_skill], status: :created
    else
      render :json => {:error => "Unable to create user at this time.", error_log: @user.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user, include: [:endorsements, :skill, :sub_skill]
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @user.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def update_password
    if @user.update(user_params)
      render json: @user
    else
      render :json => {:error => "Record not found"}, :status => :unprocessable_entity
    end
  end

  def forgot_password
    @user = User.find_by_email(params[:email])
    if @user.present?
      @user.send_reset_password_instructions
      render :json => {:success => "Please check your email #{@user.email} for password reset instructions"}, :status => :created
    else
      render :json => {:error => "Email not found"}, :status => :unprocessable_entity
    end
  end

  def get_unreviewed_events
    render json: @user.get_unreviewed_events
  end

  # need refactoring
  def facebook_auth
    unless @user
      @user = User.where(uid: params[:user][:fb_id]).first_or_initialize do |user|
        user.email = params[:user][:email]
        user.first_name = params[:user][:first_name]
        user.last_name = params[:user][:last_name]
        user.password = 'profilerfb' #Test Passwor
      end
    end
    @user.provider = 'facebook'
    @user.uid = params[:user][:fb_id]
    # by pass confirmation
    @user.confirmation_token = nil
    @user.confirmed_at = DateTime.now
    if @user.save
      @user.setup_devices(params[:PushToken],params[:platform]) if params[:PushToken].present?
      render json: @user, status: :ok
    else
      render :json => {:error => "Unable to create user at this time.", error_log: @user.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def get_user_services
    render json: @user.owned_services, include: {service_category:{}, appointments:{ include: [:user]}}, user_id: @current_user
  end

  def get_user_availed_services
    render json: @user.appointments, include: {service: {include: [:service_category, :owner]}}
  end

  def get_skilled_data
    @categories = Category.all
    render json: @categories, include: {skills: {include: :sub_skills}}, status: :ok
    # include: {info_blocks:{}, cards: {include: :info_blocks}}
  end

  def update_user_skills
    begin
      if [true, "true"].include? params[:is_skilled]
        if category = Category.find(params[:category_id])
          @user.categories.destroy_all
          @user.categories << category
        end
        # byebug
        @user.update(skill_id: params[:skill_id].to_i)
        @user.update(sub_skill_id: params[:sub_skill_id].to_i)
      end
      @user.update(is_skilled: params[:is_skilled], free_events: 2)
      render json: @user, include: [:skill, :sub_skill], status: :ok
    rescue
      render :json => {:error => "Unable to update user skills at this time."}, :status => :unprocessable_entity
    end
  end

  def add_working_days

    p_working_days = @user.working_days.ids
    tmp_id = @user.id.to_s + '000000'
    @user.working_days.update_all(user_id: tmp_id.to_i )
    if @user.update(user_params)
      WorkingDay.where("id IN(?)", p_working_days).destroy_all
      @user.reload
      render json: @user, include: [:endorsements, :skill, :sub_skill]
    else
      WorkingDay.where("id IN(?)", p_working_days).update_all(user_id: @user.id)
      render :json => {:error => "Unable to create working days at this time. Please try again later.", error_log: @user.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def search
    begin
      options = {
          # keyword: params[:keyword],
          latitude: params[:latitude],
          longitude: params[:longitude],
          distance: params[:distance],
          category: params[:category],
          min_age: params[:min_age],
          max_age: params[:max_age],
          skilled: params[:skilled],
          gender: params[:gender],
          skill: params[:skill],
          sub_skill: params[:sub_skill],
      }
      users = User.search(options)
      render json: users, current_user_id: current_user.id
    rescue
      render :json => {:error => "Unable to search profiles at this time, try again later."}, :status => :unprocessable_entity
    end
  end

  def get_user_events
    begin
      @events = @user.get_all_events
      render json: @events, include: [:ticket_packages]
    rescue
      render :json => {:error => "Unable to fetch user events at this time"}, :status => 404
    end
  end

  def user_event_reviews
  render json: @user.events, include: {reviews: {include: [:user]}}
  end

  # For Payment. (TO DO for payout and customer token should be different)
  def add_stripe_token
    if @user.update(user_params)
      render json: @user, include: [:endorsements, :skill, :sub_skill] else
      render :json => {:error => "Unable to add stripe token at this time. Please try again later.", error_log: @user.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def recent_payouts
    render json: {total_earnings:  @user.total_earnings, balanced_amount: @user.balanced_amount.round(2), payouts: @user.payments, pending_amount: 0.0}
  end

  def total_earning
    render json: {total_earnings: @user.total_earnings, received_payments: @user.received_charges}
  end

  def payout
    # details = @user.my_earning_details
    if params[:amount].to_f > @user.balanced_amount
      render json: {error: "You cannot amount greater then #{@user.balanced_amount}"}, status: :unprocessable_entity
    else
      stripe_customer = StripeCustomer.new(@user, params[:amount].to_f)
      if stripe_customer.transfer
        render json: {message: 'successfully transfer to your account.'}
      else
        render_json_response({error: 'Unable make transfer this time.', error_log: stripe_customer.errors}, :unprocessable_entity)
      end
    end
  end

  def get_bank_info
    accounts = @user.get_bank_details
    if accounts[:success]
      render json: accounts[:external_accounts]
    else
      render :json => {:error => accounts[:errors]}, status: :unprocessable_entity
    end
  end

  def contact_as
    EventMailer.contact_as(@user, params[:content], params[:subject]).deliver
    render json: {message: 'sent successfully'}
  end

  def notifications
  end

  def fetch_notifications
    @notifications = @user.notifications
  end

  def update_notification
    if params[:is_endrose].present?
      @user.update(is_endrose: params[:is_endrose])
    elsif params[:is_likes].present?
      @user.update(is_likes: params[:is_likes])
    elsif params[:is_comments].present?
      @user.update(is_comments: params[:is_comments])
    elsif params[:is_shares].present?
      @user.update(is_shares: params[:is_shares])
    elsif params[:is_tickets_sold].present?
      @user.update(is_tickets_sold: params[:is_tickets_sold])
    elsif params[:is_event_details].present?
      @user.update(is_event_details: params[:is_event_details])
    elsif params[:is_upcoming_events].present?
      @user.update(is_upcoming_events: params[:is_upcoming_events])
    elsif params[:is_book_service].present?
      @user.update(is_book_service: params[:is_book_service])
    elsif params[:is_service_notes].present?
      @user.update(is_service_notes: params[:is_service_notes])
    elsif params[:is_cancel_appointment].present?
      @user.update(is_cancel_appointment: params[:is_cancel_appointment])
    end
        
  end

  def vouchers
    if current_user.is_skilled
      @vouchers = current_user.vouchers.where(role: 'PROFILER')
    else
      @vouchers = current_user.vouchers.where(role: 'GUEST')
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    begin
      @user = User.find(params[:id])
      render :json => {:error => "User is not activated. Please check your email #{@user.email} for user activation."} unless @user.is_confirmed
    rescue
      render :json => {:error => "User not found with provided id"}, :status => 404
    end
  end

  def check_user_with_email
    return nil if params[:user][:email].blank?
    # @user1 = User.find_by_email(params[:user][:email])
    @user = User.where('email=? AND uid IS NULL', params[:user][:email]).first
  end

  def check_fb_user
    @user = User.where('email=? AND uid IS NOT NULL', params[:user][:email]).first
  end

  def check_user_skill
    render :json => {:error => "is skilled param should present"}, :status => 404 unless params[:is_skilled]
  end
  # Only allow a trusted parameter “white list” through.
  def user_params
    params.require(:user).permit(:cover_img, :refer_by, :profile_img, :zipcode, :country, :state, :city, :dob, :first_name, :last_name, :email, :password, :password_confirmation, :phone, :gender, :address, :is_skilled, :age, :latitude, :longitude, :stripe_token, :stripe_payout_token , working_days_attributes: [:work_day, :start_time, :end_time, :opened, :has_break, :break_start_time, :break_end_time])
  end

  def verify_api_token
    return true if authenticate_token
    render json: { errors: "Access denied" }, status: 401
  end

  def authenticate_token
    return false if params[:api_token].blank?
    @current_user = User.find_by(api_token: params[:api_token])
  end

end



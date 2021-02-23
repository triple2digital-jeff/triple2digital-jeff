class Api::V1::EventsController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token#, except: [:create]
  before_action :find_user, only: [:charge_event]
  before_action :set_event, only: [:show, :update, :destroy, :get_attendees, :charge_event, :event_reviews]

  # GET /events
  def index
    @events = Event.where(search_condition(Event))
    render json: @events, include: :ticket_packages, user_id: @current_user

  end

  # GET /events/1
  def show
    render json: @event, include: [:ticket_packages], user_id: @current_user
  end

  # POST /events
  def create
    # byebug
    @event = Event.new(event_params)
    @event.start_date = params[:event][:start_date].gsub("  ", " +")
    @event.end_date = params[:event][:end_date].gsub("  ", " +")
    
    if @event.save
      tokens =  UserDevice.joins(:user).active.where.not("users.is_upcoming_events = ?", "false").pluck(:push_token)
      FcmPush.new.send_push_notification('',"upcoming event",tokens) if tokens.present?
      render json: @event, include: [:ticket_packages], user_id: @current_user
    else
      render :json => {:error => "Unable to create event at this time.", error_log: @event.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    p_ticket_packages = @event.ticket_packages.ids
    tmp_id = @event.id.to_s + '000000'
    @event.ticket_packages.update_all(event_id: tmp_id.to_i )
    if @event.update(event_params)
      tokens =  UserDevice.joins(:user).active.where.not("users.is_event_details = ?", "false").pluck(:push_token)
      FcmPush.new.send_push_notification('',"Event Changed",tokens) if tokens.present?
      @event.start_date = params[:event][:start_date].gsub("  ", " +")
      @event.end_date = params[:event][:end_date].gsub("  ", " +")
      @event.save!

      TicketPackage.where("id IN(?)", p_ticket_packages).destroy_all
      @event.reload
      render json: @event, include: [:ticket_packages], user_id: @current_user
    else
      WorkingDay.where("id IN(?)", p_ticket_packages).update_all(event_id: @event.id)
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @event.errors.full_messages}, :status => :unprocessable_entity
    end

    # if @event.update(event_params)
    #   render json: @event, include: [:ticket_packages]
    # else
    #   render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @event.errors.full_messages}, :status => :unprocessable_entity
    # end
  end

  # DELETE /events/1
  def destroy
    event = @event
    if @event.destroy
      # tokens =  UserDevice.active.pluck(:push_token)
      # FcmPush.new.send_push_notification('',"#{event.owner.first_name} created new event",tokens) if tokens.present?
      render :json => {:success => "Event deleted successfully"}, :status => :ok
    else
      render :json => {:error => "Unable to delete event at this time.", error_log: @event.errors.full_messages}, :status => :unprocessable_entity
    end

  end

  def event_earning

  end

  def get_attendees

    begin
      # render json: @event, include: {tickets: {include: :owner}}
      tickets = @event.tickets
      users = User.where("id IN(?)",tickets.pluck(:owner_id).uniq)
      attandies ={}
      gateway_charges = 0.0
      my_users=[]
      users.each do |user|
        total_price = 0.0
        us = user.serializable_hash
        ticket_pckgs = user.tickets.where(event_id:@event.id).group_by(&:ticket_package_id)
        tp=[]
        ticket_pckgs.each do |pckg|
          p = TicketPackage.find(pckg.first)
          tp.push({title: p.ticket_type, scanned_count: pckg.last.count{|app| app.has_scanned == true}, tickets: pckg.last.count, price: p.price, ticket_ids: pckg.last.map(&:id)})
          total_price += (pckg.last.count* p.price.to_f).to_f
        end
        us[:packages] = tp
        us[:total_price]= total_price
        us[:gateway_charges]= gateway_charges
        my_users.push(us)
      end
      render json: my_users#, include: {tickets: {include: :owner}}
    rescue
      render :json => {:error => "Unable to get attendies at this time, try again later."}, :status => :unprocessable_entity
    end

  end

  def event_reviews
    render json: @event, include: {reviews: {include: [:user]}}
  end

  def search
    begin
      options = {
          # keyword: params[:keyword],
          latitude: params[:latitude],
          longitude: params[:longitude],
          distance: params[:distance].to_i,
          title: params[:title],
          min_price: params[:min_price],
          from_date: params[:from_date],
          to_date: params[:to_date],
      }
      events = Event.search(options)
      render json: events, include: [:ticket_packages], user_id: @current_user
    rescue
      render :json => {:error => "Unable to search events at this time, try again later."}, :status => :unprocessable_entity
    end
  end


  def save_user_event
    begin
      if params[:save] == "1"
        SavedEvent.create(user_id: params[:user_id], event_id: params[:event_id])
        msg= "saved"
      else
        SavedEvent.where(user_id: params[:user_id], event_id: params[:event_id]).destroy_all
        msg= "unsaved"
      end
      render :json => {:success => "Event has #{msg} successfully"}, :status => :ok
    rescue
      render :json => {:error => "Unable to save/unsave event at this time"}, :status => :unprocessable_entity
    end
  end

  def charge_event
    response = StripeCustomer.new(@user, params[:amount], @event).charge
    if response
    render :json => {:success => "Charge has been created successfully"}, :status => 200
    else
      render :json => {:error => "Something went wrong"}, :status => :unprocessable_entity
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    begin
      @event = Event.find(params[:id])
    rescue
      render :json => {:error => "Event not found with provided id"}, :status => 404
    end
  end

  def find_user
    begin
      @user =  User.find(params[:liked_by_id] || params[:user_id])
      render :json => {:error => "User is not activated. Please check your email #{@user.email} for user activation."} unless @user.is_confirmed
    rescue
      render :json => {:error => "User not found with provided id"}, :status => 404
    end
  end

  # Only allow a trusted parameter “white list” through.
  def event_params
    params.require(:event).permit(:latitude, :longitude, :address, :dress_code, :speaker, :start_date, :end_date, :title, :description, :status, :is_paid, :price, :owner_id, :cover_image, :has_published, :is_recurring, :recurring_type, :is_enabled, :max_tickets, ticket_packages_attributes: [:ticket_type, :price, :maximum_tickets])
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
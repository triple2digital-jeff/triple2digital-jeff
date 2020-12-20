class Api::V1::ServicesController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token#, except: [:create]
  # before_action :find_user, only: [:index]
  before_action :set_service, only: [:show, :update, :destroy, :check_available_slots_on, :service_reviews]
  before_action :validate_date, only: [:check_available_slots_on]

  # GET /services
  def index
    @services = Service.where(search_condition(Service))
    render json: @services, include: {service_category:{}, owner:{},  appointments:{ include: [:user]}}, user_id: @current_user
  end

  # GET /services/1
  def show
    render json: @service, include: {service_category:{}, owner:{},  appointments:{ include: [:user]}}, methods: [:days_timings, :average_rating], user_id: @current_user
  end

  # POST /services
  def create
    @service = Service.new(service_params)
    if @service.save
      render json: @service, include: {service_category:{}, owner:{},  appointments:{ include: [:user]}}, user_id: @current_user
    else
      render :json => {:error => "Unable to create service at this time.", error_log: @service.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /services/1
  def update
    if @service.update(service_params)
      render json: @service, include: {service_category:{}, owner:{},  appointments:{ include: [:user]}}, user_id: @current_user
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @service.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # DELETE /services/1
  def destroy
    if @service.destroy
      render :json => {:success => "Service deleted successfully"}, :status => :ok
    else
      render :json => {:error => "Unable to delete service at this time.", error_log: @service.errors.full_messages}, :status => :unprocessable_entity
    end

  end

  def service_reviews
    render json: @service, include: {reviews: {include: [:user]}}, user_id: @current_user
  end

  def check_available_slots_on
    all_slots = @service.check_time_slot_availability(@date)
    render json: all_slots
  end

  def search
    begin
      options = {
          # keyword: params[:keyword],
          latitude: params[:latitude],
          longitude: params[:longitude],
          distance: params[:distance].to_i,
          min_price: params[:min_price],
          max_price: params[:max_price],
          category: params[:category]
      }
      services = Service.search(options)
      render json: services, include: {service_category:{}, owner:{},  appointments:{ include: [:user]}}, user_id: @current_user
    rescue
      render :json => {:error => "Unable to search services at this time, try again later."}, :status => :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_service
    begin
      @service = Service.find(params[:id])
    rescue
      render :json => {:error => "Service not found with provided id"}, :status => 404
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

  def validate_date
    begin
      @date = Date.parse(params[:date])
    rescue
      render :json => {:error => "Please provide date in yyyy/mm/dd format"}, :status => :unprocessable_entity
    end
  end
  # Only allow a trusted parameter “white list” through.

  def service_params
    params.require(:service).permit(:title, :status, :note, :price, :owner_id, :is_private, :duration, :time_type, :cover_image, :service_category_id)
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
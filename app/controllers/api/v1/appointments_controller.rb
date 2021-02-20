class Api::V1::AppointmentsController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token#, except: [:create]
  # before_action :find_user, only: [:index]
  before_action :set_appointment, only: [:show, :update, :destroy]

  # GET /appointments
  def index
    @appointments = Appointment.all
    render json: @appointments#, include: {owner:{}, working_days: {}, appointments:{ include: [:user]}}
  end

  # GET /appointments/1
  def show
    render json: @appointment#, include: {owner:{}, working_days: {}, appointments:{ include: [:user]}}
  end

  # POST /appointments
  def create
    @appointment = Appointment.new(appointment_params)
    if @appointment.save
      user = @appointment.service.owner
      token = user.user_devices.active.pluck(:push_token)
      FcmPush.new.send_push_notification('',"You have new appointment",token) if token.present?
      render json: @appointment, include: {service: {include: :service_category}}
    else
      render :json => {:error => "Unable to create appointment at this time.", error_log: @appointment.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /appointments/1
  def update
    if @appointment.update(appointment_params)
      render json: @appointment#, include: {owner:{}, working_days: {}, appointments:{ include: [:user]}}
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @appointment.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # DELETE /appointments/1
  def destroy
    if @appointment.destroy
      render :json => {:success => "Appointment deleted successfully"}, :status => :ok
    else
      render :json => {:error => "Unable to delete appointment at this time.", error_log: @appointment.errors.full_messages}, :status => :unprocessable_entity
    end

  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    begin
      @appointment = Appointment.find(params[:id])
    rescue
      render :json => {:error => "Appointment not found with provided id"}, :status => 404
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

  def appointment_params
    params.require(:appointment).permit(:start_time, :end_time, :service_id, :user_id, :is_booked, :note, :appointment_date)
  end

  def verify_api_token
    return true if authenticate_token
    render json: { errors: "Access denied" }, status: 401
  end

  def authenticate_token
    return false if params[:api_token].blank?
    User.find_by(api_token: params[:api_token])
  end


end
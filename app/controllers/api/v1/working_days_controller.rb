class Api::V1::WorkingDaysController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token#, except: [:create]
  # before_action :find_user, only: [:index]
  before_action :set_working_day, only: [:show, :update, :destroy]

  # GET /working_days
  def index
    @working_days = WorkingDay.all
    render json: @working_days#, include: {owner:{}, working_days: {}, appointments:{ include: [:user]}}
  end

  # GET /working_days/1
  def show
    @user= @working_day.user
    render json: @user#, include: {owner:{}, working_days: {}, appointments:{ include: [:user]}}
  end

  # POST /working_days
  def create
    @working_day = WorkingDay.new(working_day_params)
    if @working_day.save
      @user = @working_day.user
      render json: @user#, include: {owner:{}, working_days: {}, appointments:{ include: [:user]}}
    else
      render :json => {:error => "Unable to create working day at this time.", error_log: @working_day.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /working_days/1
  def update
    if @working_day.update(working_day_params)
      render json: @working_day, include: {owner:{}, working_days: {}, appointments:{ include: [:user]}}
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @working_day.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # DELETE /working_days/1
  def destroy
    if @working_day.destroy
      render :json => {:success => "Working Day deleted successfully"}, :status => :ok
    else
      render :json => {:error => "Unable to delete working day at this time.", error_log: @working_day.errors.full_messages}, :status => :unprocessable_entity
    end

  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_working_day
    begin
      @working_day = WorkingDay.find(params[:id])
    rescue
      render :json => {:error => "Working Day not found with provided id"}, :status => 404
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
  def working_day_params
    params.require(:working_day).permit(:start_time, :end_time, :work_day, :opened, :user_id, :has_break, :break_start_time, :break_end_time)
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
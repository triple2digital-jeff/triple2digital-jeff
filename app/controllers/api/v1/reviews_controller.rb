class Api::V1::ReviewsController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token#, except: [:create]
  # before_action :find_user, only: []
  before_action :set_review, only: [:show, :update, :destroy]

  # GET /reviews
  def index
    @reviews = Review.all
    render json: @reviews, include: [:user]
  end

  # GET /reviews/1
  def show
    render json: @review, include: [:user]
  end

  # Review /reviews
  def create
    @review = Review.new(review_params)
    if @review.save
      user = @review.reviewable.owner
      token = user.user_devices.active.pluck(:push_token)
      FcmPush.new.send_push_notification('',"#{@review.user.first_name} Left a review for your #{@review.reviewable_type}",token) if token.present?
      user.notifications.create(notification_type: 'left_review', description: "Left a review for your #{@review.reviewable_type}", notifier_id: user.try(:id), object_id: @review.id)
      render json: @review, include: [:user]
    else
      render :json => {:error => "Unable to create review at this time.", error_log: @review.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(review_params)
      render json: @review, include: [:user]
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @review.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def rereview

    if @review.touch
      render json: @review
    else
      render :json => {:error => "Unable to rereview record this time. Please try again later.", error_log: @review.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # DELETE /reviews/1
  def destroy
    if @review.destroy
      render :json => {:success => "Review deleted successfully"}, :status => :ok
    else
      render :json => {:error => "Unable to delete review at this time.", error_log: @review.errors.full_messages}, :status => :unprocessable_entity
    end

  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_review
    begin
      @review = Review.find(params[:id])
    rescue
      render :json => {:error => "Review not found with provided id"}, :status => 404
    end
  end

  def find_user
    begin
      @user =  User.find(params[:user_id])
      render :json => {:error => "User is not activated. Please check your email #{@user.email} for user activation."} unless @user.is_confirmed
    rescue
      render :json => {:error => "User not found with provided id"}, :status => 404
    end
  end


  # Only allow a trusted parameter “white list” through.
  def review_params
    params.require(:review).permit(:comment, :rating, :reviewable_id, :reviewable_type, :user_id, :status)
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
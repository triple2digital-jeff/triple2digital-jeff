class Api::V1::CommentsController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token
  before_action :find_user, only: [:create, :update, :destroy]
  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /comments
  def index
    @comments = Comment.all
    render json: @comments
  end

  # GET /comments/1
  def show
    # @comment.comment_image = @comment.profile_image
    render json: @comment
  end

  # Comment /comments
  def create
    @comment = Comment.new(comment_params)
    # debugger
    # @comment.password=@comment.password_confirmation=pass

    if @comment.save
      user = @comment.post.user
      device = user.user_devices.active.first
      FcmPush.new.send_push_notification('',"#{@comment.user.first_name} comment your post",device.try(:push_token), device.try(:platform)) if device.present?
      render json: @comment, status: :created
    else
      render :json => {:error => "Unable to create comment at this time.", error_log: @comment.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      # if params[:image].present?
      #   process_comment_image(@comment, params[:image])
      # end
      # @comment.comment_image = @comment.profile_image
      render json: @comment, inludes: [:comments]
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @comment.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy

    if @comment.destroy
      render :json => {:success => "Comment deleted successfully"}, :status => :ok
    else
      render :json => {:error => "Unable to delete comment at this time.", error_log: @comment.errors.full_messages}, :status => :unprocessable_entity
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    begin
      @comment = Comment.find(params[:id])
    rescue
      render :json => {:error => "Comment not found with provided id"}, :status => 404
    end
  end

  def find_user
    begin
      @user =  User.find(params[:comment][:user_id])
    rescue
      render :json => {:success => "User not found with provided id"}, :status => 404
    end
  end

  # Only allow a trusted parameter “white list” through.
  def comment_params
    params.require(:comment).permit(:post_id, :description, :user_id)
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
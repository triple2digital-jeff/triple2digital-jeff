class Api::V1::MessagesController < ApplicationController

  before_action :verify_api_token

  def create
    message = Message.new(message_params)
    if message.save
      ChatChannel.broadcast_to message.chat, message
      render json: {status: 'sent'}, status: :created
    else
      render json: { error: 'Unable to sent message at this time.', error_log: message.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def find_user
    begin
      @user =  User.find(params[:user_id])
      render json: {error: "User is not activated. Please check your email #{@user.email} for user activation."} unless @user.is_confirmed
    rescue
      render json: {error: 'User not found with provided id'}, status: 404
    end
  end

  def message_params
    params.require(:message).permit(:body, :sender_id, :receiver_id, :chat_id)
  end

  def verify_api_token
    return true if authenticate_token
    render json: { errors: 'Access denied' }, status: 401
  end

  def authenticate_token
    return false if params[:api_token].blank?
    User.find_by(api_token: params[:api_token])
  end
end
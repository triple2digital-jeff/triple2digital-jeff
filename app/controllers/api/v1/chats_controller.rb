class Api::V1::ChatsController < ApplicationController

  before_action :verify_api_token

  def index
    chats = Chat.where('sender_id = ? OR receiver_id = ?', @user.id, @user.id)
    render json: chats, include: [:sender, :receiver, :last_message]
  end

  def create
    chat = Chat.new(chat_params)
    if chat.save
      ActionCable.server.broadcast "conversations_channel_#{chat.receiver_id}", chat
      ActionCable.server.broadcast "conversations_channel_#{chat.sender_id}", chat
      render json: chat, include: [:sender, :receiver, :last_message]
    else
      render json: { error: 'Unable to create chat at this time.', error_log: chat.errors.full_messages}, status: :unprocessable_entity
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

  def chat_params
    params.require(:chat).permit(:sender_id, :receiver_id)
  end

  def verify_api_token
    return true if authenticate_token
    render json: { errors: 'Access denied' }, status: 401
  end

  def authenticate_token
    return false if params[:api_token].blank?
    @user = User.find_by(api_token: params[:api_token])
  end
end
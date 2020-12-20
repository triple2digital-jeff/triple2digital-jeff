class ChatChannel < ApplicationCable::Channel
  def subscribed
    find_chat

    stream_for @chat
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    find_chat
    message = Message.create!(body: data[:message], sender_id: data[:sender_id], receiver_id:  data[:receiver_id], chat_id: @chat.id)
    ChatChannel.broadcast_to @chat, message
  end

  private

  def find_chat
    @chat = Chat.find(params[:chat])
    verify_api_token
  end

  def verify_api_token
    return true if authenticate_token
    ChatChannel.broadcast_to(@chat, data: { errors: 'Access denied' }, code: 422)
  end

  def authenticate_token
    return false if params[:api_token].blank?
    User.find_by(api_token: params[:api_token])
  end
end

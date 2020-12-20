class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversations_channel_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

class ChatroomChannel < ApplicationCable::Channel
  def subscribed
  	# byebug
    stream_from "room_channel_#{params[:chatroom_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # POST /messages
  # POST /messages.json
  def create
    @message = current_user.messages.build(message_params)

    if @message.save
      ActionCable.server.broadcast "room_channel_#{@message.chatroom_id}", message: render_message(@message)
    else
      flash[:error] = "Couldn't save message! #{@message.errors.full_messages.join(", ")}"
      redirect_to root_path
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.permit(:content, :chatroom_id)
    end

    def render_message(message)
      render(partial: "message", locals: {message: message})
    end
end

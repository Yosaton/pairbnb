class ChatroomsController < ApplicationController
  before_action :require_login
  before_action :set_chatroom, only: [:show]

  # GET /chatrooms
  # GET /chatrooms.json
  def index
    @chatrooms = Chatroom.all
  end

  # GET /chatrooms/1
  # GET /chatrooms/1.json
  def show
  end


  def create
    target_user = User.find_by_id(chatroom_params[:format])
    # Check if the target user and current user have a subscription to the same chatroom_id
    similar_chatrooms = current_user.chatrooms.ids.select{ |item| target_user.chatrooms.ids.include?(item)}
    if(similar_chatrooms.length != 0)
      @chatroom = Chatroom.find_by_id(similar_chatrooms.first)
    else
      @chatroom = Chatroom.new(name: "Chat between #{current_user.full_name} and #{target_user.full_name}")

      if @chatroom.save
        Chatroom.transaction do
          current_user.subscriptions.create(chatroom_id: @chatroom.id)
          target_user.subscriptions.create(chatroom_id: @chatroom.id)
        end
      else

      end
    end

    redirect_to chatroom_path(@chatroom)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatroom
      @chatroom = Chatroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chatroom_params
      params.permit(:format)
    end
end

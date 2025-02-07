class UsersController < ApplicationController
  def chat
    @user = User.find(params[:id])
    @current_user = current_user
    @rooms = Room.public_rooms
    @users = User.all_except(@current_user)
    @room = Room.new
    @message = Message.new
    @room_name = get_name(@user, @current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, @current_user], @room_name)
    @messages = @single_room.messages

    render 'rooms/index'
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream { render partial: 'users/modal', locals: { user: @user } }
    end
  end

  def index
    @query = User.ransack(search_query)
    @users = @query.result
  end

  private

  def search_query
    return {} unless params[:q]

    logger.info(params[:q][:search])
    query = params[:q][:search]&.strip
    return {} if query.blank?

    { username_or_email_or_first_name_or_last_name_cont_any: query.split }
  end

  def get_name(user1, user2)
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end
end

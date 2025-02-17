module Rooms
  class Index
    @room = Room.new
    @rooms = Room.public_rooms
    @users = User.all_except(current_user)
  end
end

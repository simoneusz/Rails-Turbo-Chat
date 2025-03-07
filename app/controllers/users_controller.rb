# frozen_string_literal: true

class UsersController < ApplicationController
  def chat
    @user = User.find(params[:id])
    @room_name = get_name(@user, current_user)

    redirect_to Room.where(name: @room_name).first || Rooms::CreatePeerRoomService.new({ name: @room_name,
                                                                                         is_private: true },
                                                                                       current_user,
                                                                                       @user)
                                                                                  .call.data
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream { render partial: 'users/user_info_modal', locals: { user: @user } }
    end
  end

  def search
    @query = User.ransack(search_query)
    @search_results = @query.result

    respond_to do |format|
      format.html { render partial: 'search/search_results', locals: { search_results: @search_results } }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('search_results', partial: 'search/search_results',
                                                                    locals: { search_results: @search_results })
      end
    end
  end

  private

  def get_name(user1, user2)
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end
end

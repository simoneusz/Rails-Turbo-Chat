# frozen_string_literal: true

class UsersController < ApplicationController
  def chat
    room = Users::OpenPrivateChatService.new(current_user, User.find(params[:id])).call.data
    redirect_to room
  end

  def show
    @user = User.find(params[:id])

    respond_with_user_modal(:user_info_modal)
  end

  def edit
    @user = User.find(params[:id])

    respond_with_user_modal(:edit_user_modal)
  end

  def update
    result = Users::UpdateService.call(params[:id], user_params)

    if result.success?
      set_flash_and_redirect(:notice, 'Edited successfully', request.referer)
    else
      redirect_back fallback_location: root_path, alert: result.error_message
    end
  end

  def search # rubocop:disable Metrics/MethodLength
    result = Users::SearchQueryService.new(params).call.data

    @query = result[:query]
    @search_results = result[:results]

    respond_to do |format|
      format.html { render partial: 'search/search_results', locals: { search_results: @search_results } }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'search_results',
          partial: 'search/search_results',
          locals: { search_results: @search_results }
        )
      end
    end
  end

  def change_status
    Users::ChangeStatusService.new(params[:id], params[:status]).call

    redirect_to request.referer
  end

  private

  def respond_with_user_modal(modal_name)
    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "users/#{modal_name}", locals: { user: @user } }
    end
  end

  def private_room_name(user1, user2)
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :avatar, :display_name)
  end
end

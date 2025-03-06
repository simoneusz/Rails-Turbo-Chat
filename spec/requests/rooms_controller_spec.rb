# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:room) { create(:room) }

  before { sign_in user }

  describe 'GET #index' do
    it 'assigns @rooms and @users' do
      get :index
      expect(assigns(:rooms)).to eq(Room.public_rooms)
      expect(assigns(:users)).to eq(User.all_except(user))
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    let(:room_params) { { name: 'Test Room', is_private: false } }

    context 'when room creation succeeds' do
      subject { post :create, params: { room: room_params } }
      it 'creates a new room and redirects' do
        allow(Rooms::CreateRoomService).to receive_message_chain(:new, :call).and_return(
          double(success?: true, data: room)
        )

        subject
        expect(response).to redirect_to(room_path(room))
        expect(flash[:notice]).to eq('New room has been created')
      end
    end

    context 'when room creation fails' do
      subject { post :create, params: { room: room_params } }
      it 'renders an error' do
        allow(Rooms::CreateRoomService).to receive_message_chain(:new, :call).and_return(
          double(success?: false, error_code: 'creation_failed', data: room)
        )

        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include('errors.creation_failed')
      end
    end
  end

  describe 'GET #show' do
    context 'when user is authorized' do
      subject { get :show, params: { id: room.id } }
      before do
        allow(controller).to receive(:authorized_to_view?).and_return(true)
        allow(room).to receive(:user_blocked?).with(user).and_return(false)
      end

      it 'assigns necessary variables and renders index' do
        subject
        expect(assigns(:single_room)).to eq(room)
        expect(response).to render_template(:index)
      end
    end

    context 'when user is unauthorized' do
      subject { get :show, params: { id: room.id } }
      it 'redirects with an alert' do
        allow(controller).to receive(:authorized_to_view?).and_return(false)

        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You do not have permission to view this room')
      end
    end

    context 'when user is blocked' do
      subject { get :show, params: { id: room.id } }
      it 'redirects to rooms with an alert' do
        allow(controller).to receive(:authorized_to_view?).and_return(true)
        allow(room).to receive(:user_blocked?).with(user).and_return(true)

        room.participants.create(user: user, role: :blocked)

        subject
        expect(response).to redirect_to(rooms_path)
        expect(flash[:alert]).to eq('You are banned in this room')
      end
    end
  end

  describe 'GET #all' do
    context 'when user is unauthorized' do
      it 'assigns paginated rooms in reverse order' do
        get :all
        expect(assigns(:rooms)).to eq(Room.public_rooms.order(created_at: :desc).limit(15).reverse)
      end
    end
  end

  describe 'POST #add_participant' do
    before { allow(controller).to receive(:authorize_room) }

    context 'when service succeeds' do
      subject { post :add_participant, params: { id: room.id, user_id: another_user.id } }
      it 'adds a participant and redirects' do
        allow(Participants::AddParticipantService).to receive_message_chain(:new, :call).and_return(
          double(success?: true, data: room)
        )

        subject
        expect(response).to redirect_to(room_path(room))
        expect(flash[:notice]).to include("#{another_user.username} was added")
      end
    end

    context 'when service fails' do
      subject { post :add_participant, params: { id: room.id, user_id: another_user.id } }
      it 'renders an error' do
        allow(Participants::AddParticipantService).to receive_message_chain(:new, :call).and_return(
          double(success?: false, error_code: 'add_failed', data: room)
        )

        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include('errors.add_failed')
      end
    end
  end

  describe 'DELETE #remove_participant' do
    before { allow(controller).to receive(:authorize_room) }
    context 'when service succeeds' do
      subject { delete :remove_participant, params: { id: room.id, user_id: another_user.id } }
      it 'removes a participant and redirects' do
        allow(Participants::RemoveParticipantService).to receive_message_chain(:new, :call).and_return(
          double(success?: true, data: room)
        )

        subject
        expect(response).to redirect_to(room_path(room))
        expect(flash[:notice]).to include("#{another_user.username} was removed")
      end
    end
  end

  describe 'PATCH #change_role' do
    before { allow(controller).to receive(:authorize_room) }

    context 'when service succeeds' do
      subject { patch :change_role, params: { id: room.id, user_id: another_user.id, role: 'moderator' } }
      it 'changes role and redirects' do
        allow(Participants::ChangeParticipantRoleService).to receive_message_chain(:new, :call).and_return(
          double(success?: true, data: room)
        )

        subject
        expect(response).to redirect_to(room_path(room))
        expect(flash[:notice]).to include("Role for #{another_user.username} changed to moderator")
      end
    end
  end

  describe 'authorization' do
    context 'when user is not authorized' do
      subject { post :add_participant, params: { id: room.id, user_id: another_user.id } }
      it 'redirects with an alert' do
        allow(controller).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)

        subject
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to perform this action')
      end
    end
  end
end

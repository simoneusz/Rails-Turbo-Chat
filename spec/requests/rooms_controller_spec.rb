# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:room) { create(:room) }

  before { sign_in user }

  describe 'GET #index' do
    subject(:get_index) { get :index }

    before { get_index }

    it 'assigns @rooms' do
      expect(assigns(:rooms)).to eq(Room.public_rooms)
    end

    it 'assigns @users' do
      expect(assigns(:users)).to eq(User.excluding(user))
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    let(:room_params) { { name: 'Test Room', is_private: false } }
    let(:invalid_room_params) { { name: nil, is_private: false } }

    context 'when room creation succeeds' do
      subject(:create_room) { post :create, params: { room: room_params } }

      before { create_room }

      it 'creates a new room and redirects' do
        expect(response).to redirect_to(Room.last)
      end
    end

    context 'when room creation fails' do
      subject(:create_room) { post :create, params: { room: invalid_room_params } }

      before { create_room }

      it 'renders an error' do
        expect(response).to redirect_to(rooms_path)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is authorized' do
      subject(:get_show) { get :show, params: { id: room.id } }

      before do
        allow(controller).to receive(:authorized_to_view?).and_return(true)
        allow(room).to receive(:user_blocked?).with(user).and_return(false)
        get_show
      end

      it 'assigns necessary variables and renders index' do
        expect(assigns(:single_room)).to eq(room)
      end

      it 'renders the show template' do
        expect(response).to render_template(:index)
      end
    end

    context 'when user is unauthorized' do
      subject(:get_show) { get :show, params: { id: room.id } }

      before do
        allow(controller).to receive(:authorized_to_view?).and_return(false)
        get_show
      end

      it 'redirects' do
        expect(response).to redirect_to(rooms_path)
      end
    end

    context 'when user is blocked' do
      subject(:get_show) { get :show, params: { id: room.id } }

      before do
        allow(controller).to receive(:authorized_to_view?).and_return(true)
        allow(room).to receive(:user_blocked?).with(user).and_return(true)

        room.participants.create(user: user, role: :blocked)

        get_show
      end

      it 'redirects to rooms with an alert' do
        expect(response).to redirect_to(rooms_path)
      end
    end
  end

  describe 'GET #all' do
    subject(:get_all) { get :all }

    before { get_all }

    context 'when user is authorized' do
      it 'assigns paginated rooms in reverse order' do
        expect(assigns(:rooms)).to eq(Room.public_rooms.order(created_at: :desc).limit(15).reverse)
      end
    end
  end
end

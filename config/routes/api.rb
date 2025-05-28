# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    devise_scope :user do
      post    'login',  to: 'users/sessions#create'
      delete  'logout', to: 'users/sessions#destroy'
      post    'signup', to: 'users/registrations#create'
    end

    resources :contacts, only: %i[index create] do
      collection do
        patch :accept
        post :accept_all
        delete :delete
        post  :reject
      end
    end

    resources :users, only: [:show, :create, :update, :destroy] do
      patch :change_status
    end

    resources :rooms, only: [:index, :show, :create, :update, :destroy] do
      collection do
        get :all
        get :dms
      end

      member do
        post :join
        delete :leave
      end

      resources :messages, controller: 'messages', only: %i[create destroy]
      resources :participants, controller: 'participants' do
        post    :change_role
        patch   :toggle_notifications
      end
    end

    resources :favorites, only: [] do
      post :toggle, on: :collection
    end

    resources :notifications, only: [:index] do
      patch :mark_as_read, on: :member
    end
  end

  match '*unmatched', to: 'errors#not_found', via: :all
end
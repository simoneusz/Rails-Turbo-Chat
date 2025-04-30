# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    devise_scope :user do
      post 'login', to: 'users/sessions#create'
      delete 'logout', to: 'users/sessions#destroy'
      post 'signup', to: 'users/registrations#create'
    end

    namespace :contacts do
      resources :contacts, only: [:index, :create, :update, :destroy] do
        post :accept_all, on: :collection
        delete :delete, on: :member
      end
    end

    namespace :users do
      resources :users, only: [:index, :show, :create, :update, :destroy] do
        patch :change_status
        get :current, on: :collection
      end
    end

    namespace :rooms do
      resources :rooms, only: [:index, :show, :create, :update, :destroy] do

      end
    end
  end
end
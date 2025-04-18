# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root 'home#index'

  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: {
    sessions:           'users/sessions',
    registrations:      'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks',
    confirmations:      'users/confirmations'
  }

  resources :users do
    member do
      get   :chat
      patch :change_status
    end
  end
  get 'search_users', to: 'users#search'

  get 'dms', to: 'rooms#dms'

  resources :rooms do
    collection do
      get :all
    end

    resources :messages, only: %i[create destroy]

    resources :participants, only: %i[create destroy] do
      member do
        post   :block
        post   :unblock
        post   :change_role
        post   :join
        patch  :toggle_notifications
        delete :leave
      end
    end
  end

  resources :messages, only: [] do
    resources :reactions, only: %i[create]
    delete 'reactions', to: 'reactions#destroy'
  end

  resources :favorites, only: [] do
    post :toggle, on: :collection
  end

  resources :contacts, only: %i[index create update destroy] do
    collection do
      get  :requests
      post :accept_all
    end
    delete :delete, on: :member
  end

  resources :notifications, only: %i[index] do
    patch :mark_as_read, on: :member
  end

  get 'up', to: 'rails/health#show', as: :rails_health_check
end
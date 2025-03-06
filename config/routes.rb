# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  root 'home#index'

  resources :users do
    member do
      get :chat
    end
  end
  get 'search_users', to: 'users#search'
  get 'dms', to: 'rooms#dms'
  resources :rooms do
    resources :messages, only: %i[create destroy]
    post 'add_participant', on: :member
    delete 'remove_participant', on: :member
    post 'block_participant', on: :member
    post 'unblock_participant', on: :member
    post 'accept_invitation', on: :member
    post 'join', on: :member
    delete 'leave', on: :member
    post 'change_role', on: :member
    get 'all', on: :collection
  end
  resources :contacts, only: %i[index create update destroy] do
    collection do
      get 'requests'
    end
  end
  resources :notifications, only: %i[index] do
    patch 'mark_as_read', on: :member
  end
  get 'up' => 'rails/health#show', as: :rails_health_check
end

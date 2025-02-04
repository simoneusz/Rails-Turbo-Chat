# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  root 'rooms#index'

  resources :users do
    member do
      get :chat
    end
  end

  resources :rooms do
    resources :messages
  end
  resources :contacts, only: %i[index create update destroy] do
    collection do
      get 'requests'
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end

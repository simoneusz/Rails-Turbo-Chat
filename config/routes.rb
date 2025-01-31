# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  root 'rooms#index'

  resources :users
  resources :rooms do
    resources :messages
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end

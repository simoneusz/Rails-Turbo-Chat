# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    devise_scope :user do
      post    'login',  to: 'users/sessions#create'
      delete  'logout', to: 'users/sessions#destroy'
      post    'signup', to: 'users/registrations#create'
    end

    namespace :contacts do
      resources :contacts, only: [:index, :create, :update, :destroy] do
        post    :accept_all,  on: :collection
        delete  :delete,      on: :member
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

      resources :messages, controller: 'messages', only: %i[create destroy]
      resources :participants, controller: 'participants' do
        post    :change_role
        patch   :toggle_notifications
      end
    end
  end

  match '*unmatched', to: 'errors#not_found', via: :all
end
# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  root to: "pages#home"
  namespace :account do
    resources :users, only: [:index]
    namespace :admin do
      resources :users, except: %i[new create edit update] do
        member do
          put 'change_user_status', to: 'users#change_user_status'
          put 'change_admin_permission', to: 'users#change_admin_permission'
        end
      end
    end
  end
end

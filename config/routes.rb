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
      resources :categories do
        member do
          patch 'move_position', to: 'categories#move_position'
          put 'change_cat_visibility', to: "categories#change_cat_visibility"
        end
        resources :sub_categories do
          member do
            put 'change_sub_visibility', to: 'sub_categories#change_sub_visibility'
            put 'move_to_category', to: 'sub_categories#move_to_category'
            patch 'move_position', to: 'sub_categories#move_position'
          end
          resources :teams do
            member do
              get 'move_to_sub_category', to: 'teams#move_to_sub_category'
              put 'change_team_visibility', to: 'teams#change_team_visibility'
              put 'move_to_sub_category', to: 'teams#move_to_sub_category'
              patch 'move_position', to: 'teams#move_position'
            end
          end
        end
      end
    end
  end
end

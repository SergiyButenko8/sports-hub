Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  namespace :account do
    namespace :admin do
      resources  :users do
        member do
          put 'change_user_status', to: 'users#change_user_status'
          put 'change_admin_permission', to: 'users#change_admin_permission'
        end
      end
    end
  end
end

Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  namespace :account do
    namespace :admin do
      resources  :users do
        member do
          put 'remove_from_admin', to: 'users#remove_from_admin'
          put 'add_to_admin', to: 'users#add_to_admin'
          put 'block_user', to: 'users#block_user'
          put 'activate_user', to: 'users#activate_user'
        end
        #put 'remove_from_admin', to: 'users#remove_from_admin', on: :member
      end
    end
  end
end

Rails.application.routes.draw do
  devise_for :users
  root "pages#home"
  namespace :account do
    namespace :admin do
      resources  :users, only: [:index, :show]
    end
  end

end

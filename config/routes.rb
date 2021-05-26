Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  namespace :account do
    namespace :admin do
      resources  :users, only: [:index, :show, :edit, :update, :destroy]
    end
  end

end

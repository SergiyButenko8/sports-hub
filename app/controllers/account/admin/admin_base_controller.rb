# frozen_string_literal: true

module Account::Admin
  class AdminBaseController < Account::AccountBaseController
    before_action :top_categories
    include Pundit
    layout "admin_layout"
    rescue_from Pundit::NotAuthorizedError, with: :user_not_admin

    private

    def top_categories
      @categories = Category.all.order(position: :asc)
    end

    def user_not_admin
      flash[:alert] = "You don't have permission to visit this page."
      redirect_to account_users_path
    end
  end
end

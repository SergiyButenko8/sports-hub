# frozen_string_literal: true

module Account::Admin
  class AdminBaseController < Account::AccountBaseController
    layout "admin_layout"
    before_action :check_admin_access?

    private

    def check_admin_access?
      unless current_user.admin?
        flash[:alert] = "No permissions!"
        redirect_to account_users_path
      end
    end
  end
end

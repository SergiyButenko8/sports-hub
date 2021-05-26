module Account::Admin
  class AdminBaseController < Account::AccountBaseController
    before_action :check_admin_access?
    private
    def check_admin_access?
      if !current_user.admin?
        render :file => "public/401.html", :status => :unauthorized
      end
    end
  end
end
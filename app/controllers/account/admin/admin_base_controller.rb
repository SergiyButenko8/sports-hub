module Account::Admin
  class AdminBaseController < Account::AccountBaseController
    layout "admin_layout"
    #before_action :check_admin_access?
    #private
    #def check_admin_access?
      #if current_user.admin?
      #end
    #end
  end
end

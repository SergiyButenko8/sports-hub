module Account::Admin
  class UsersController < AdminBaseController
    layout "admin_layout"
    def index
      @users = User.all
      render "users/index"
    end
    def show
      @user = User.find(params[:id])
      render "users/show"
    end
  end
end

module Account::Admin
  class UsersController < AdminBaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy, :remove_from_admin, :add_to_admin, :activate_user, :block_user]
    layout "admin_layout"
    def index
      @users = User.where(role: 'user')
      @admins = User.where(role: 'admin')
      #render "users/index"
    end
    def show
      #render "users/show"
    end
    def edit
      #render "users/edit"
    end

    def update
      if @user.update(user_params)
        redirect_to account_admin_users_path
      else
        #render "users/edit"
      end
    end

    def add_to_admin
      @user.role = "admin"
      if @user.save
        redirect_to account_admin_users_path
      end
    end

    def remove_from_admin
      @user.role = "user"
      if @user.save
        redirect_to account_admin_users_path
      end
    end

    def block_user
      @user.blocked!
      if @user.save
        redirect_to account_admin_users_path
      end
    end

    def activate_user
      @user.active!
      if @user.save
        redirect_to account_admin_users_path
      end
    end

    def destroy
      @user.destroy
      flash[:notice] = "Account has been removed"
      redirect_to account_admin_users_path
    end

    private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :status, :role)
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end

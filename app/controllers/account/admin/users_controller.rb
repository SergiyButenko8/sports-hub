# frozen_string_literal: true

module Account::Admin
  class UsersController < AdminBaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy, :change_user_status, :change_admin_permission, :full_name]
    def index
      @users = User.where(role: 'user')
      @admins = User.where(role: 'admin')
    end

    def show
    end

    def edit
    end

    def update
      if @user.update(user_params)
        flash[:notice] = "User has been successfully updated"
        redirect_to account_admin_users_path
      else
        flash[:error] = "Error.."
        render "account/admin/users/edit"
      end
    end

    def change_admin_permission
      user_role = @user.user? ? "admin" : "user"
      if @user.update(role: user_role)
        redirect_to account_admin_users_path, notice: "User #{@user.email} is an #{user_role} now"
      else
        flash[:error] = "Error.."
        render 'account/admin/users/index'
      end
    end

    def change_user_status
      user_status = @user.active? ? "blocked" : "active"
      if @user.update(status: user_status)
        redirect_to account_admin_users_path, notice: "User #{@user.email} is #{user_status} now"
      else
        flash[:error] = "Error.."
        render 'account/admin/users/index'
      end
    end

    def destroy
      if the_same_user?
        flash[:notice] = "You cannot remove your own account"
      else
        if @user.destroy
          flash[:notice] = "Account has been removed"
        else
          flash[:error] = "Error.."
          render 'account/admin/users/index'
        end
      end
      redirect_to account_admin_users_path
    end

    private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :status, :role)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def the_same_user?
      @user == current_user
    end
  end
end

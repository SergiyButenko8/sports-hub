# frozen_string_literal: true

module Account::Admin
  class UsersController < AdminBaseController
    before_action :set_user,
                  only: %i[show edit update destroy change_user_status change_admin_permission]
    before_action :not_current_user, only: %i[destroy change_admin_permission]
    before_action :authorize_admin_user
    def index
      @q = User.ransack(params[:q])
      @all_users = @q.result
      @users = @all_users.user
      @admins = @all_users.admin
    end

    def show; end

    def edit; end

    def update
      if @user.update(user_params)
        flash[:notice] = "User has been successfully updated"
        redirect_to account_admin_users_path
      else
        flash.now[:alert] = "Error. User has not been changed."
        render "edit"
      end
    end

    def change_admin_permission
      if @user.active? && user_params[:role] != @user.role && @user.update(user_params)
        flash[:notice] = "User #{@user.email} is an #{user_params[:role]} now"
      else
        flash[:alert] = "Role has not been changed due to wrong parameter."
      end
      redirect_to account_admin_users_path
    end

    def change_user_status
      if @user.status != user_params[:status] && @user.update(user_params)
        flash[:notice] = "User #{@user.email} is #{user_params[:status]} now"
      else
        flash[:alert] = "Status has not been changed due to wrong parameter."
      end
      redirect_to account_admin_users_path
    end

    def destroy
      if @user.destroy
        flash[:notice] = "Account has been removed"
      else
        flash[:alert] = "Error.."
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

    def not_current_user
      if @user == current_user
        flash[:alert] = "This action is not allowed for your own account"
        redirect_to account_admin_users_path
      end
    end

    def authorize_admin_user
      authorize current_user
    end
  end
end

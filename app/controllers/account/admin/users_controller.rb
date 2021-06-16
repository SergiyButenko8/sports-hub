# frozen_string_literal: true

module Account::Admin
  class UsersController < AdminBaseController
    before_action :not_current_user, only: %i[destroy change_admin_permission]
    before_action :authorize_admin_user, only: %i[index show change_admin_permission change_user_status destroy]
    before_action :set_page_title

    def index
      @q = User.ransack(params[:q])
      @all_users = @q.result
      @users = @all_users.user
      @admins = @all_users.admin
    end

    def show
      user
    end

    def change_admin_permission
      if user.active? && user_params[:role] != user.role && user.update(user_params)
        UserMailer.change_permission_email(user).deliver_later
        flash[:notice] = "User #{user.email} is #{user_params[:role]} now"
      else
        flash[:alert] = "Role has not been changed due to wrong parameter."
      end
      redirect_to account_admin_users_path
    end

    def change_user_status
      if user.status != user_params[:status] && user.update(user_params)
        UserMailer.change_status_email(user).deliver_later
        flash[:notice] = "User #{user.email} is #{user_params[:status]} now"
      else
        flash[:alert] = "Status has not been changed due to wrong parameter."
      end
      redirect_to account_admin_users_path
    end

    def destroy
      if user.destroy
        UserMailer.delete_account_email(user).deliver_now
        respond_to do |format|
          format.js { flash.now[:notice] = "User #{user.full_name} deleted" }
          format.html { redirect_to account_admin_users_path, notice: "User #{user.full_name} deleted" }
        end
      else
        respond_to do |format|
          format.js { flash.now[:alert] = "Error" }
          format.html { redirect_to account_admin_users_path, alert: "Error.." }
        end
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :status, :role)
    end

    def user
      @user ||= User.find(params[:id])
    end

    def not_current_user
      if user == current_user
        flash[:alert] = "This action is not allowed for your own account"
        redirect_to account_admin_users_path
      end
    end

    def authorize_admin_user
      authorize current_user
    end

    def set_page_title
      @page_title = "Users"
    end
  end
end

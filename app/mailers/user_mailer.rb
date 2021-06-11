class UserMailer < ApplicationMailer
  def change_permission_email(user)
    notify_user(user, "Role change notification")
  end

  def change_status_email(user)
    notify_user(user, "Status change notification")
  end

  def delete_account_email(user)
    notify_user(user, "Your account removed")
  end

  def send_registration_email(user)
    notify_user(user, "Subscription in Sports Hub")
  end

  def notify_user(user, subject)
    @user = user
    attachments.inline['check_mark.png'] = File.read("#{Rails.root}/app/assets/images/check_mark.png")
    mail(to: @user.email, subject: subject)
  end
end

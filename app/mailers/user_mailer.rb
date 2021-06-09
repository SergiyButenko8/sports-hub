class UserMailer < ApplicationMailer
  def change_permission_email(user)
    @user = user
    attachments.inline['check_mark.png'] = File.read("#{Rails.root}/app/assets/images/check_mark.png")
    mail(to: @user.email, subject: "Role change notification")
  end

  def change_status_email(user)
    @user = user
    attachments.inline['check_mark.png'] = File.read("#{Rails.root}/app/assets/images/check_mark.png")
    mail(to: @user.email, subject: "Status change notification")
  end

  def delete_account_email(user)
    @user = user
    attachments.inline['check_mark.png'] = File.read("#{Rails.root}/app/assets/images/check_mark.png")
    mail(to: @user.email, subject: "You account removed")
  end
end

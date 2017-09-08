class SendPasswordMailer < ApplicationMailer
  #send email after create account when login first by WSM account
  def user_created_wsm user, password
    @user = user
    @password = password
    mail to: @user.email,
      subject: t("subject_mail_after_create")
  end
end

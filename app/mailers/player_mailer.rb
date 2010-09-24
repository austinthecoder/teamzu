class PlayerMailer < ActionMailer::Base

  def message_email(email_attrs = {})
    mail(
      :to => email_attrs
    )
  end

end

class PlayerMailer < ActionMailer::Base

  def bulk_message(players, from_email, subject, body)
    @msg = body
    mail(
      :to => players.map(&:email),
      :from => Teamzu::MAILER_EMAIL,
      :reply_to => from_email,
      :subject => subject
    )
  end

end

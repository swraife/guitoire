class UserMailer < ApplicationMailer
  def new_message_alert(user, message)
    @recipient = user
    @message = message

    mail(
      to: @recipient.email,
      subject: "You have a new message from #{@message.user.name}"
      ) do |format|
        format.html { render layout: 'mailer' }
        format.text
    end
  end
end
require 'json'

class UserMailer < ApplicationMailer

  def new_message_alert(user, message)
    @recipient = user
    @message = message
    @subject = "You have a new message from #{@message.user.name}"

    mail(to: @recipient.email, subject: @subject) do |format|
      format.html { render layout: 'mailer' }
      format.text
    end
  end
end
require 'sendgrid-ruby'
require 'json'

class UserMailer < ApplicationMailer
  include SendGrid
  def new_message_alert(user, message)
    @recipient = user
    @message = message

    mail = Mail.new(
      to: @recipient.email,
      subject: "You have a new message from #{@message.user.name}"
      ) do |format|
        format.html { render layout: 'mailer' }
        format.text
    end

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'], host: 'https://api.sendgrid.com')
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end
end
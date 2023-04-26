class Api::SmsController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def receive
      message_body = params["Body"]
      from_number = params["From"]
  
      # Handle incoming SMS message
      # ...
  
      render plain: "Message received", status: :ok
    end
  
    def send_message
      to_number = params["to"]
      message_body = params["message"]
  
      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  
      message = client.messages.create(
        body: message_body,
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: to_number
      )
  
      return "SMS sent successfully!"
    end
  end
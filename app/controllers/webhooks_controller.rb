class WebhooksController < ApplicationController
  def twilio
    body = params['Body'].downcase

    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message body: "You said: \"#{body}\""
    end

    render xml: twiml.to_s
  end
end

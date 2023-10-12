class WebhooksController < ApplicationController
  def twilio
    result = Webhooks::ProcessMessage.call(message: params['Body'])

    body = result.success? ? result.value : result.error.message

    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message body:
    end

    render xml: twiml.to_s
  end
end

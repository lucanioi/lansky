class WebhooksController < ApplicationController
  def twilio
    result = Webhooks::ProcessMessage.call(
      message: params['Body'],
      phone: params['From']
    )

    body = result.success? ? result.value : '500: Internal server error'

    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message body:
    end

    render xml: twiml.to_s
  end
end

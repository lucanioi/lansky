class WebhooksController < ApplicationController
  before_action :ensure_user

  def twilio
    result = Chatbot::Engine.run(user:, message: params['Body'])

    body = result.success? ? result.value : 'Internal server error'

    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message body: body
    end

    render xml: twiml.to_s
  end

  private

  def user
    @user ||= Users::FindOrCreate.run(phone: params['From']).value!
  end

  def ensure_user
    head :forbidden unless user
  end
end

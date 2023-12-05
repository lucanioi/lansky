class WebhooksController < ApplicationController
  around_action :set_time_zone, if: :current_user

  def twilio
    @phone_number = params['From']

    result = Webhooks::ProcessMessage.call(
      message: params['Body'],
      user: current_user
    )

    body = result.success? ? result.value : result.error.message

    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message body:
    end

    render xml: twiml.to_s
  end

  private

  def current_user
    @current_user ||= Users::FindOrCreate.call(phone: @phone_number).value
  end

  def set_time_zone(&block)
    Time.use_zone('Madrid/Spain', &block)
  end
end

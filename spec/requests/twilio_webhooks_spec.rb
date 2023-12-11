require 'rails_helper'

RSpec.describe 'Twilio Webhooks', type: :request do
  before do
    Timecop.freeze(DateTime.new(2023, 10, 12, 22, 30, 0))

    allow(Chatbot::Engine)
      .to receive(:run)
        .with(user:, message: message) { engine_result }
  end

  after { Timecop.return }

  let(:user) { create :user, phone: phone, test_user: false }
  let(:phone) { '1234567890' }
  let(:message) { 'foo bar' }
  let(:engine_result) { Runnable::Result.new(value: expected_response) }
  let(:expected_response) { 'foo bar bar bar' }

  it 'responds with a 200 status' do
    send_request

    expect(response).to have_http_status(200)
  end

  it 'responds with result from chatbot engine' do
    send_request

    expect(response.body).to eq(format_twiml(expected_response))
  end

  def build_params(body)
    {
      'Body' => body,
      'From' => phone,
    }
  end

  def send_request
    post '/webhooks/twilio', params: build_params(message)
  end
end

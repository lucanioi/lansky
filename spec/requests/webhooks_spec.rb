require 'rails_helper'

RSpec.describe 'Webhooks', type: :request do
  describe 'POST /twilio' do
    let(:valid_params) do
      {
        'Body' => body,
        'From' => '+1234567890',
      }
    end
    let(:body) { 'Hello from the Irish countryside!' }
    # let(:service_result) { Service::Result.new(value: "You said: \"#{body}\"") }

    before do
      # allow(ChatBot::ProcessMessage).to receive(:call).with(body: body) { service_result }

      post '/webhooks/twilio', params: valid_params
    end

    it 'responds with a 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'responds with a message echoing the body in TwiML format' do
      expect(response.body).to eq(format_twiml("This is what you said: \"#{body}\""))
    end
  end
end

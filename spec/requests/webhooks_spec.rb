require 'rails_helper'

RSpec.describe 'Webhooks', type: :request do
  describe 'POST /twilio' do
    let(:valid_params) do
      {
        'Body' => 'Hello from the Irish countryside!',
        'From' => '+1234567890',
      }
    end

    before do
      post '/webhooks/twilio', params: valid_params
    end

    it 'responds with a 200 status' do
      expect(response).to have_http_status(200)
    end

    it 'responds with a message echoing the body in TwiML format' do
      expected_response = <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Message>You said: "hello from the irish countryside!"</Message>
        </Response>
      XML

      expect(response.body).to eq(expected_response)
    end
  end
end

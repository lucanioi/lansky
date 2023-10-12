require 'rails_helper'

RSpec.describe 'Webhooks', type: :request do
  describe 'POST /twilio' do
    let(:body) { '' }
    let(:valid_params) do
      {
        'Body' => body,
        'From' => '+1234567890',
      }
    end

    before do
      post '/webhooks/twilio', params: valid_params
    end

    it 'responds with a 200 status' do
      expect(response).to have_http_status(200)
    end

    context 'given a message it does not recognize' do
      let(:body) { 'Hello from the Irish countryside!' }

      it 'responds with a message echoing the body in TwiML format' do
        expect(response.body).to eq(format_twiml('no comprendo'))
      end
    end
  end
end

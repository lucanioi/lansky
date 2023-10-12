require 'rails_helper'

RSpec.describe 'Twilio Webhooks', type: :request do
  let(:message) { '' }

  before do
    Timecop.freeze(Time.zone.local(2023, 10, 1, 12, 0, 0))
  end

  it 'responds with a 200 status' do
    make_request

    expect(response).to have_http_status(200)
  end

  describe 'message it does not recognize' do
    let(:message) { 'Hello from the Irish countryside!' }

    it 'responds with a message echoing the body in TwiML format' do
      make_request

      expect(response.body).to eq(format_twiml('no comprendo'))
    end
  end

  describe 'setting budget' do
    let(:message) { 'set budget this month 1000' }

    it 'responds with a message echoing the body in TwiML format' do
      make_request

      expect(response.body).to eq(format_twiml('Budget for October set to €1,000'))

      # make_request('budget this month')

      # expect(response.body).to eq(format_twiml('Your budget for October is €1,000'))
    end
  end

  def build_params(body)
    {
      'Body' => body,
      'From' => '+1234567890',
    }
  end

  def make_request(body = message)
    post '/webhooks/twilio', params: build_params(body)
  end
end

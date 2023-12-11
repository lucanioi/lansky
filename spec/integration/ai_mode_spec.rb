require 'rails_helper'

RSpec.describe 'AI Mode', type: :request do
  let(:mode) { :ai }

  before { Timecop.freeze(DateTime.new(2023, 10, 12, 22, 30, 0)) }
  after  { Timecop.return }

  let(:user) { create :user, test_user: false }

  # describe 'message it does not recognize' do
  #   it 'responds with a message echoing the body in TwiML format' do
  #     send_message    'Does not recognize this message'
  #     expect_response 'Did not understand'
  #   end
  # end

  describe 'happy path', :vcr do
    it 'responds with correct response' do
      send_message    'get budget this month 1000'
      expect_response 'No budget set for October 2023'
    end
  end

  def send_message(message)
    @response = Chatbot::Engine.run(user:, message:, mode:).value!
  end

  def expect_response(body)
    expect(@response).to eq(body)
  end
end
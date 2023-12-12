require 'rails_helper'

RSpec.describe 'AI Mode', type: :engine do
  let(:mode) { :ai }

  before { Timecop.freeze(DateTime.new(2024, 2, 29, 8, 25, 0)) }
  after  { Timecop.return }

  let(:user) { create :user, test_user: false }

  describe 'message it does not recognize', :vcr do
    it 'responds with Did not understand' do
      send_message    'Does not recognize this message'
      expect_response 'Did not understand'
    end
  end

  describe 'happy path', :vcr do
    it 'responds with correct response' do
      send_message    'get budget this month'
      expect_response 'No budget set for February 2024'

      send_message    'set budget february 2500'
      expect_response 'Budget for February 2024 set to €2,500'

      send_message    'Hey man, whats good. how much money do ' \
                      'I have allocated for the current month? cheers mate.'
      expect_response 'Budget for February 2024 is €2,500'

      send_message    'yo just spent 20 on burgers'
      expect_response 'Spent €20 on burgers'

      send_message    'what is my spending for today?'
      expect_response <<~TEXT.strip
                        Total spent (Thu, 29 Feb 2024):
                        *€20*

                        ```20.00``` - burgers
                      TEXT

      send_message    '今日はどれくらい出費しましたか。'
      expect_response <<~TEXT.strip
                        Total spent (Thu, 29 Feb 2024):
                        *€20*

                        ```20.00``` - burgers
                      TEXT

      send_message    'hello darling. how much money do I have left for the month?'
      expect_response <<~TEXT.strip
                        You have *€2,480* left for the day. You've spent *€20*.

                        You have *€2,480* left for February 2024.

                        Current daily limit is *€2,480*.
                      TEXT

      send_message    'I wanted to set my local timezone. I am currenly in ' \
                      'Kaunus, Lithuania. I am not sure what timezone that is.'
      expect_response 'Timezone set to Europe/Vilnius +02:00'

      send_message    'what is my timezone?'
      expect_response 'Timezone: Europe/Vilnius +02:00'

      send_message    'set my currency to JPY please'
      expect_response 'Currency set to JPY'

      send_message    'whats the currency again? sorry for asking repeatedly'
      expect_response 'Currency: JPY'

      send_message    'actually, I would like to set my currency back to EUR'
      expect_response 'Currency set to EUR'

      send_message    'I would also like to set my timezone back to UTC'
      expect_response 'Timezone set to UTC +00:00'
    end
  end

  def send_message(message)
    config = { embellish_response: false }

    @response = Chatbot::Engine.run(user:, message:, mode:, config:).value!
  end

  def expect_response(body)
    expect(@response).to eq(body)
  end
end

require 'rails_helper'

RSpec.describe 'Classic Mode', type: :request do
  let(:mode) { :classic }

  before { Timecop.freeze(DateTime.new(2023, 10, 12, 22, 30, 0)) }
  after  { Timecop.return }

  let(:user) { create :user, test_user: false }

  describe 'message it does not recognize' do
    it 'responds with \'Did not understand\'' do
      send_message    'Does not recognize this message'
      expect_response 'Did not understand'
    end
  end

  describe 'happy path' do
    it 'responds with correct response' do
      send_message    'set budget this month 1000'
      expect_response 'Budget for October 2023 set to €1,000'

      send_message    'get budget this month'
      expect_response 'Budget for October 2023 is €1,000'

      Timecop.freeze 1.day.ago do
        send_message    'spent 10 food'
        expect_response 'Spent €10 on food'
      end

      send_message    'spent 20 food'
      expect_response 'Spent €20 on food'

      send_message   'status'
      expect_response <<~TEXT.strip
                        You have *€29.50* left for the day. You've spent *€20*.

                        You have *€970* left for October 2023.

                        Current daily limit is *€49.50*.
                      TEXT

      Timecop.freeze 2.hours.ago do
        send_message    'spent 5.25 drinks'
        expect_response 'Spent €5.25 on drinks'
      end

      send_message    'spending today'
      expect_response <<~TEXT.strip
                        Total spent (Thu, 12 Oct 2023):
                        *€25.25*

                        ```20.00``` - food
                        ``` 5.25``` - drinks
                      TEXT

      send_message    'spending this month'
      expect_response <<~TEXT.strip
                        Total spent (October 2023):
                        *€35.25*

                        ```30.00``` - food
                        ``` 5.25``` - drinks
                      TEXT

      send_message    'set timezone Madrid'
      expect_response 'Timezone set to Madrid +02:00' # summer time

      send_message    'timezone'
      expect_response 'Timezone: Madrid +02:00' # summer time

      send_message    'spending today'
      expect_response <<~TEXT.strip
                        Total spent (Fri, 13 Oct 2023):
                        *€20*

                        ```20.00``` - food
                      TEXT

      send_message    'set timezone UTC'
      expect_response 'Timezone set to UTC +00:00'

      send_message    'set currency JPY'
      expect_response 'Currency set to JPY'

      send_message    'currency'
      expect_response 'Currency: JPY'

      send_message    'spending today'
      expect_response <<~TEXT.strip
                        Total spent (Thu, 12 Oct 2023):
                        *¥2,525*

                        ```2,000``` - food
                        ```  525``` - drinks
                      TEXT

      send_message    'set currency EUR'
      expect_response 'Currency set to EUR'

      send_message    'recovered 5.25 food'
      expect_response 'Recovered €5.25 (food)'

      send_message    'status'
      expect_response <<~TEXT.strip
                        You have *€29.50* left for the day. You've spent *€25.25* and recovered *€5.25*.

                        You have *€970* left for October 2023.

                        Current daily limit is *€49.50*.
                      TEXT
    end
  end

  def send_message(message)
    @response = Chatbot::Engine.run(user:, message:, mode:).value!
  end

  def expect_response(body)
    expect(@response).to eq(body)
  end
end

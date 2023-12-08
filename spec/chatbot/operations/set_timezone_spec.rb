require 'rails_helper'

RSpec.describe Chatbot::Operations::SetTimezone do
  before { Timecop.freeze(DateTime.new(2023, 12, 6)) }
  after  { Timecop.return }

  it_behaves_like 'operation', {
    'basic' => {
      input: 'set timezone Madrid',
      output: 'Timezone set to Madrid +01:00',
    },
    'UTC' => {
      input: 'set timezone UTC',
      output: 'Timezone set to UTC +00:00',
    },
    'invalid timezone' => {
      input: 'set timezone foobar',
      output: 'invalid timezone: foobar',
    },
    'missing timezone' => {
      input: 'set timezone',
      output: 'you need to specify a timezone',
    },
  }

  describe 'state changes' do
    let(:result) { run_operation(user:, message:) }
    let(:message) { 'set timezone Madrid' }
    let(:user) { create :user }

    it 'sets the user timezone' do
      expect(user.timezone).to eq('UTC')

      result

      expect(user.timezone).to eq('Madrid')
    end
  end
end

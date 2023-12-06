require 'rails_helper'

RSpec.describe Chatbot::Operations::SetTimezone do
  before do
    Timecop.freeze(DateTime.new(2023, 12, 6))
  end

  it_behaves_like 'operation', {
    'basic' => {
      input: 'set timezone Madrid',
      output: 'Timezone set to Madrid +01:00',
    },
    'invalid timezone' => {
      input: 'set timezone foobar',
      output: 'invalid timezone: foobar',
    },
  }

  describe 'state changes' do
    let(:result) { described_class.new(user:, message:).execute }
    let(:message) { 'set timezone Madrid' }
    let(:user) { create :user }

    it 'sets the user timezone' do
      expect(user.timezone).to eq('UTC')

      result

      expect(user.timezone).to eq('Madrid')
    end
  end
end

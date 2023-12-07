require 'rails_helper'

RSpec.describe Chatbot::Operations::SetCurrency do
  before { Timecop.freeze(DateTime.new(2023, 10, 12)) }
  after  { Timecop.return }

  it_behaves_like 'operation', {
    'basic' => {
      input: 'set currency EUR',
      output: 'Currency set to EUR',
    },
    'lowercase' => {
      input: 'set currency jpy',
      output: 'Currency set to JPY',
    },
    'invalid currency' => {
      input: 'set currency foobar',
      output:  'invalid currency: foobar',
    },
    'missing currency' => {
      input: 'set currency',
      output:  'you need to specify a currency',
    },
  }

  describe 'state changes' do
    let(:result) { described_class.new(user:, message:).execute }
    let(:message) { 'set currency JPY' }
    let(:user) { create :user }

    it 'sets the user currency' do
      expect(user.currency).to be_nil

      result

      expect(user.currency).to eq('JPY')
    end
  end
end

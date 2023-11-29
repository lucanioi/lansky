require 'rails_helper'

RSpec.describe Chatbot::Commands::Spent do
  it_behaves_like 'command', {
    'basic' => {
      input: 'spent 10.32 food',
      output: 'Spent €10.32 on food',
    },
    'multi-word category' => {
      input: 'spent 0.50 cat food',
      output: 'Spent €0.50 on cat food',
    },
    'no category' => {
      input: 'spent 100',
      output: 'Spent €100 (uncategorized)',
    },
    'invalid amount' => {
      input: 'spent 98oi3j',
      error: 'invalid amount',
    },
    'missing amount' => {
      input: 'spent food',
      error: 'invalid amount',
    },
    'missing arguments' => {
      input: 'spent',
      error: 'invalid amount',
    },
  }

  describe 'state changes' do
    let(:result) { described_class.new(message).execute }
    let(:message) { 'spent 5.50 food' }

    it 'creates a spending' do
      expect { result }.to change { Spending.count }.by(1)
    end

    it 'sets the spending amount' do
      result

      expect(Spending.last.amount_in_cents).to eq(550)
    end

    it 'sets the spending category' do
      result

      expect(Spending.last.category.name).to eq('food')
    end
  end
end

require 'rails_helper'

RSpec.describe Chatbot::Operations::Spent do
  it_behaves_like 'operation', {
    'basic' => {
      input: 'spent 10.32 food',
      output: 'Spent €10.32 on food',
    },
    'single decimal point' => {
      input: 'spent 10.5 food',
      output: 'Spent €10.50 on food'
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
    'rounding issues' =>{
      input: 'spent 4.60 groceries',
      output: 'Spent €4.60 on groceries',
    }
  }

  describe 'state changes' do
    let(:result) { described_class.new(user:, message:).execute }
    let(:message) { 'spent 5.50 food' }
    let(:user) { create :user }

    it 'creates a spending' do
      expect { result }.to change { user.ledger_entries.count }.by(1)
    end

    it 'sets the spending amount' do
      result

      expect(user.ledger_entries.last.amount_cents).to eq(550)
    end

    it 'sets the spending category' do
      result

      expect(user.ledger_entries.last.category.name).to eq('food')
    end
  end
end

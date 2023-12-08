require 'rails_helper'

RSpec.describe Chatbot::Operations::Recovered do
  it_behaves_like 'operation', {
    'basic' => {
      input: 'recovered 10.32 food',
      output: 'Recovered €10.32 (food)',
    },
    'single decimal point' => {
      input: 'recovered 10.5 food',
      output: 'Recovered €10.50 (food)',
    },
    'multi-word category' => {
      input: 'recovered 0.50 cat food',
      output: 'Recovered €0.50 (cat food)',
    },
    'no category' => {
      input: 'recovered 100',
      output: 'Recovered €100 (uncategorized)',
    },
    'Invalid amount' => {
      input: 'recovered 98oi3j',
      output: 'Invalid amount',
    },
    'missing amount' => {
      input: 'recovered food',
      output: 'Invalid amount',
    },
    'missing arguments' => {
      input: 'recovered',
      output: 'Invalid amount',
    },
    'rounding issues' =>{
      input: 'recovered 4.60 groceries',
      output: 'Recovered €4.60 (groceries)',
    }
  }

  describe 'state changes' do
    let(:result) { run_operation(user:, message:) }
    let(:message) { 'recovered 5.50 food' }
    let(:user) { create :user }

    it 'creates a ledger entry' do
      expect { result }.to change { user.ledger_entries.count }.by(1)
    end

    it 'sets the recovery amount' do
      result

      expect(user.ledger_entries.last.amount_cents).to eq(550)
    end

    it 'sets the recovery category' do
      result

      expect(user.ledger_entries.last.category.name).to eq('food')
    end
  end
end

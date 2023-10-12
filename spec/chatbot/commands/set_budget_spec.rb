require 'rails_helper'

RSpec.describe Chatbot::Commands::SetBudget do
  it_behaves_like 'command', {
    'this month' => {
      input: 'set budget this month 1000',
      output: 'Budget for October set to €1,000',
    },
    'next month' => {
      input: 'set budget next month 1000',
      output: 'Budget for November set to €1,000',
    },
    'january' => {
      input: 'set budget january 1000',
      output: 'Budget for January set to €1,000',
    },
    'money with euro sign' => {
      input: 'set budget january €1000',
      output: 'Budget for January set to €1,000',
    },
    'money with euro sign and a comma' => {
      input: 'set budget january €1,000',
      output: 'Budget for January set to €1,000',
    },
    'money with full variation' => {
      input: 'set budget january 1,000.00',
      output: 'Budget for January set to €1,000',
    },
    'invalid month' => {
      input: 'set budget invalid month 1000',
      error:  'invalid month',
    },
    'invalid amount' => {
      input: 'set budget january 98oi3j',
      error:  'invalid amount',
    },
  }

  describe 'state changes' do
    let(:result) { described_class.new(message).execute }
    let(:message) { 'set budget this month 1000' }

    it 'creates a budget' do
      expect { result }.to change { Budget.count }.by(1)
    end

    it 'sets the budget amount' do
      result

      expect(Budget.last.amount_in_cents).to eq(1000_00)
    end

    it 'sets the budget period' do
      result

      expect(Budget.last.period_start).to eq(Date.today.beginning_of_month)
      expect(Budget.last.period_end).to eq(Date.today.end_of_month)
    end

    context 'when the specified month is for next year' do
      let(:message) { 'set budget january 1000' }

      it 'sets the budget period' do
        result

        expect(Budget.last.period_start).to eq(Date.new(Date.today.year + 1, 1, 1))
        expect(Budget.last.period_end).to eq(Date.new(Date.today.year + 1, 1, 31))
      end
    end

    context 'when budget already exists for the month' do
      let!(:budget) do
        create :budget,
                period_start: Date.today.beginning_of_month,
                period_end: Date.today.end_of_month,
                amount_in_cents: 500_00
      end

      it 'updates the budget' do
        expect { result }
          .to change { budget.reload.amount_in_cents }
            .from(budget.amount_in_cents).to(1000_00)
      end
    end
  end
end

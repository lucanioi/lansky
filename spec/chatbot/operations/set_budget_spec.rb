require 'rails_helper'

RSpec.describe Chatbot::Operations::SetBudget do
  before { Timecop.freeze(DateTime.new(2023, 10, 12)) }
  after  { Timecop.return }

  it_behaves_like 'operation', {
    'this month' => {
      input: 'set budget this month 1000',
      output: 'Budget for October 2023 set to €1,000',
    },
    'next month' => {
      input: 'set budget next month 1000',
      output: 'Budget for November 2023 set to €1,000',
    },
    'january next year' => {
      input: 'set budget january 1000',
      output: 'Budget for January 2024 set to €1,000',
    },
    'money with euro sign' => {
      input: 'set budget january €1000',
      output: 'Budget for January 2024 set to €1,000',
    },
    'money with euro sign and a comma' => {
      input: 'set budget january €1,000',
      output: 'Budget for January 2024 set to €1,000',
    },
    'money with full variation' => {
      input: 'set budget january 1,000.00',
      output: 'Budget for January 2024 set to €1,000',
    },
    'invalid month' => {
      input: 'set budget foobar 1000',
      output:  'Invalid period',
    },
    'Invalid amount' => {
      input: 'set budget january 98oi3j',
      output:  'Invalid amount',
    },
  }

  describe 'state changes' do
    let(:result) { run_operation(user:, message:) }
    let(:message) { 'set budget this month 1000' }
    let(:user) { create :user }

    it 'creates a budget' do
      expect { result }.to change { user.budgets.count }.by(1)
    end

    it 'sets the budget amount' do
      result

      expect(user.budgets.last.amount_cents).to eq(1000_00)
    end

    it 'sets the budget period' do
      result

      expect(user.budgets.last.period_start).to approx_eq(DateTime.current.bom)
      expect(user.budgets.last.period_end).to approx_eq(DateTime.current.bom.next_month)
    end

    context 'when the specified month is for next year' do
      let(:message) { 'set budget january 1000' }

      it 'sets the budget period' do
        result

        expect(user.budgets.last.period_start).to approx_eq(DateTime.new(DateTime.current.year + 1, 1, 1))
        expect(user.budgets.last.period_end).to approx_eq(DateTime.new(DateTime.current.year + 1, 2, 1))
      end
    end

    context 'when budget already exists for the month' do
      let!(:budget) do
        create :budget,
                period_start: DateTime.current.bom,
                period_end: DateTime.current.bom.next_month,
                amount_cents: 500_00,
                user:
      end

      it 'updates the budget' do
        expect { result }
          .to change { budget.reload.amount_cents }
            .from(budget.amount_cents).to(1000_00)
      end
    end
  end
end

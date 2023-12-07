require 'rails_helper'

RSpec.describe Chatbot::Operations::GetBudget do
  before do
    Timecop.freeze(DateTime.new(2023, 10, 12))

    create :budget,
            period_start: DateTime.new(2023, 10, 1),
            period_end: DateTime.new(2023, 10, 31).eod,
            amount_cents: 1000_00,
            user:
  end

  after { Timecop.return }

  it_behaves_like 'operation', {
    'basic' => {
      input: 'get budget october',
      output: 'Budget for October 2023 is €1,000',
    },
    'this month' => {
      input: 'get budget this month',
      output: 'Budget for October 2023 is €1,000',
    },
    'next month' => {
      input: 'get budget next month',
      output: 'No budget set for November 2023',
    },
    'abbreviated' => {
      input: 'budget october',
      output: 'Budget for October 2023 is €1,000',
    },
  }
end

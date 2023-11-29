require 'rails_helper'

RSpec.describe Chatbot::Commands::GetBudget do
  before do
    Timecop.freeze(Date.new(2023, 10, 12))

    create :budget,
            period_start: Date.new(2023, 10, 1),
            period_end: Date.new(2023, 10, 31),
            amount_in_cents: 1000_00,
            user:
  end

  it_behaves_like 'command', {
    'basic' => {
      input: 'get budget october',
      output: 'Budget for October is €1,000',
    },
    'this month' => {
      input: 'get budget this month',
      output: 'Budget for October is €1,000',
    },
    'next month' => {
      input: 'get budget next month',
      output: 'No budget set for November',
    },
    'abbreviated' => {
      input: 'budget october',
      output: 'Budget for October is €1,000',
    },
  }
end

require 'rails_helper'

RSpec.describe Chatbot::Operations::Spending do
  before do
    Timecop.freeze(DateTime.new(2023, 10, 12, 12, 0, 0))

    # today's spendings
    create_spending(32_00, 1.hour.ago, 'food')
    create_spending(10_00, 30.minutes.ago, 'food')
    create_spending(80_88, 2.hours.ago, 'clothes')

    # this month's spendings
    create_spending(200_00, 5.days.ago, 'clothes')
  end

  after { Timecop.return }

  it_behaves_like 'operation', {
    'today' => {
      input: 'spending today',
      output: "Total spent (Thu, 12 Oct 2023):\n" \
              "*€122.88*\n\n" \
              "```80.88``` - clothes\n" \
              "```42.00``` - food"
    },
    'October' => {
      input: 'spending october',
      output: "Total spent (October 2023):\n" \
              "*€322.88*\n\n" \
              "```280.88``` - clothes\n" \
              "``` 42.00``` - food"
    },
    'No spendings' => {
      input: 'spending last month',
      output: "No spendings found for September 2023"
    },
    'Given period is future' => {
      input: 'spending next month',
      output: "No spendings found for November 2023"
    },
    'Invalid period' => {
      input: 'spending foobar',
      error: "invalid period: foobar"
    },
    'No period given' => {
      input: 'spending',
      error: "no period specified"
    }
  }

  def create_spending(amount_cents, recorded_at, category)
    create :ledger_entry, user:, amount_cents:, recorded_at:,
           category: LedgerCategory.find_or_create_by(name: category),
           entry_type: :spending
  end
end

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

  it_behaves_like 'operation', {
    'today' => {
      input: 'spending today',
      output: "Total spent (Thu, 12 oct 2023):\n" \
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
  }

  def create_spending(amount_in_cents, spent_at, category)
    create :spending, user:, amount_in_cents:, spent_at:,
           category: SpendingCategory.find_or_create_by(name: category)
  end
end

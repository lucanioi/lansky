require 'rails_helper'

RSpec.describe Chatbot::Operations::Status do
  before do
    Timecop.freeze(Date.new(2023, 12, 15))

    create_budget_current_month 1_000_00
  end

  it_behaves_like 'operation', {
    'no spending' => {
      input: 'status',
      output: "You have €1,000 left for December.\n\n" \
              "That's €58.82 per day for the rest of the month."
    },
    '100 euros spent' => {
      input: 'status',
      setup: 'create_spending 100_00, 5.days.ago',
      output: "You have €900 left for December.\n\n" \
              "That's €52.94 per day for the rest of the month."
    },
    'multiple spendings' => {
      input: 'status',
      setup: "create_spending 100_00, 5.days.ago; create_spending 200_00, 10.days.ago",
      output: "You have €700 left for December.\n\n" \
              "That's €41.17 per day for the rest of the month."
    },
    'spending in other month' => {
      input: 'status',
      setup: 'create_spending 100_00, 1.month.ago',
      output: "You have €1,000 left for December.\n\n" \
              "That's €58.82 per day for the rest of the month."
    },
    'spending in other year' => {
      input: 'status',
      setup: 'create_spending 100_00, 1.year.ago',
      output: "You have €1,000 left for December.\n\n" \
              "That's €58.82 per day for the rest of the month."
    },
    'leap year' => {
      input: 'status',
      setup: 'Timecop.freeze(Date.new(2024, 2, 15)); create_budget_current_month 1_000_00; create_spending 100_00, 1.day.ago',
      output: "You have €900 left for February.\n\n" \
              "That's €60 per day for the rest of the month."
    },
    'no budget set'  => {
      input: 'status',
      setup: 'user.budgets.destroy_all',
      output: 'No budget set for current period.'
    },
    'last day of month' => {
      input: 'status',
      setup: 'Timecop.freeze(Date.new(2023, 12, 31))',
      output: "You have €1,000 left for December.\n\n" \
              "That's €1,000 per day for the rest of the month."
    },
    'spending with decimal amount' => {
      input: 'status',
      setup: 'create_spending 100_50, 5.days.ago',
      output: "You have €899.50 left for December.\n\n" \
              "That's €52.91 per day for the rest of the month."
    },
    'spent more than budget' => {
      input: 'status',
      setup: 'create_spending 1_100_00, 5.days.ago',
      output: "You are over budget by €100 for December."
    }
  }

  def create_spending(amount, spent_at)
    create :spending, user:, amount_in_cents: amount, spent_at:
  end

  def create_budget_current_month(amount)
    create :budget,
           user: user,
           amount_in_cents: amount,
           period_start: Date.today.beginning_of_month,
           period_end: Date.today.end_of_month
  end
end

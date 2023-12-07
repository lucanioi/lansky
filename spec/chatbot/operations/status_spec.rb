require 'rails_helper'

RSpec.describe Chatbot::Operations::Status do
  before do
    Timecop.freeze(DateTime.new(2023, 12, 15, 12))

    create_budget_current_month 1_000_00
  end

  after { Timecop.return }

  it_behaves_like 'operation', {
    'no spending' => {
      input: 'status',
      output: "You have *€58.82* left today. You haven't spent anything yet.\n\n" \
              "You have *€1,000* left for December 2023.\n\n" \
              "Current daily limit is *€58.82*."
    },
    '100 euros spent' => {
      input: 'status',
      setup: 'create_spending 100_00, 5.days.ago',
      output: "You have *€52.94* left today. You haven't spent anything yet.\n\n" \
              "You have *€900* left for December 2023.\n\n" \
              "Current daily limit is *€52.94*."
    },
    '20 euros spent today' => {
      input: 'status',
      setup: 'create_spending 20_00, 1.hour.ago',
      output: "You have *€38.82* left today. You've already spent *€20*.\n\n" \
              "You have *€980* left for December 2023.\n\n" \
              "Current daily limit is *€58.82*."
    },
    'multiple spendings' => {
      input: 'status',
      setup: "create_spending 100_00, 5.days.ago; create_spending 20_00, 2.hours.ago; create_spending 10_00, 2.hours.ago",
      output: "You have *€22.94* left today. You've already spent *€30*.\n\n" \
              "You have *€870* left for December 2023.\n\n" \
              "Current daily limit is *€52.94*."
    },
    'spending in other month' => {
      input: 'status',
      setup: 'create_spending 100_00, 1.month.ago',
      output: "You have *€58.82* left today. You haven't spent anything yet.\n\n" \
              "You have *€1,000* left for December 2023.\n\n" \
              "Current daily limit is *€58.82*."
    },
    'spending in other year' => {
      input: 'status',
      setup: 'create_spending 100_00, 1.year.ago',
      output: "You have *€58.82* left today. You haven't spent anything yet.\n\n" \
      "You have *€1,000* left for December 2023.\n\n" \
      "Current daily limit is *€58.82*."
    },
    'leap year' => {
      input: 'status',
      setup: 'Timecop.freeze(DateTime.new(2024, 2, 15)); create_budget_current_month 1_000_00; create_spending 100_00, 1.day.ago',
      output: "You have *€60* left today. You haven't spent anything yet.\n\n" \
              "You have *€900* left for February 2024.\n\n" \
              "Current daily limit is *€60*."
    },
    'no budget set'  => {
      input: 'status',
      setup: 'user.budgets.destroy_all',
      output: 'No budget set for current period.'
    },
    'last day of month' => {
      input: 'status',
      setup: 'Timecop.freeze(DateTime.new(2023, 12, 31))',
      output: "You have *€1,000* left today. You haven't spent anything yet.\n\n" \
              "You have *€1,000* left for December 2023.\n\n" \
              "Current daily limit is *€1,000*."
    },
    'spending with decimal amount' => {
      input: 'status',
      setup: 'create_spending 100_50, 5.days.ago',
      output: "You have *€52.91* left today. You haven't spent anything yet.\n\n" \
              "You have *€899.50* left for December 2023.\n\n" \
              "Current daily limit is *€52.91*."
    },
    'budget for period surpassed' => {
      input: 'status',
      setup: 'create_spending 1_100_00, 5.days.ago',
      output: "You are over budget by *€100* for December 2023."
    },
    'budget for the day surpassed' => {
      intput: 'status',
      setup: 'create_spending 70_00, 1.hour.ago',
      output: "You are over budget by *€11.18* today.\n\n" \
              "You have *€930* left for December 2023.\n\n" \
              "Adjusted daily limit is *€58.12* for the rest of the period."
    },
    'spent exactly the daily limit' => {
      input: 'status',
      setup: 'create_spending 58_82, 1.hour.ago',
      output: "Today's spending is spot on the budget, exactly *€58.82*.\n\n" \
              "You have *€941.18* left for December 2023.\n\n" \
              "Daily limit remains at *€58.82* for the rest of the period."
    },
    'spent exactly the period budget' => {
      input: 'status',
      setup: 'create_spending 1_000_00, 1.day.ago',
      output: "You've spent the total budget of *€1,000*.\n\n" \
              "No remaining budget for December 2023. You can overwrite and increase the budget by the `set budget` operation." \
    }
  }

  def create_spending(amount_cents, recorded_at)
    create :ledger_entry, user:, amount_cents:, recorded_at:, entry_type: :spending
  end

  def create_budget_current_month(amount)
    create :budget,
           user: user,
           amount_cents: amount,
           period_start: Time.zone.today.bom,
           period_end: Time.zone.today.eom
  end
end

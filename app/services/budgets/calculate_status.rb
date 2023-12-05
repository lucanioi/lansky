module Budgets
  class CalculateStatus
    include Service

    BudgetStatus = Struct.new(
      :amount_spent_today,
      :amount_left_today,
      :amount_left_for_period,
      :amount_left_per_day,
      keyword_init: true
    )

    def call
      BudgetStatus.new(
        amount_spent_today:,
        amount_left_today:,
        amount_left_for_period:,
        amount_left_per_day:
      )
    end

    private

    def amount_left_today
      amount_left_per_day - amount_spent_today
    end

    def amount_left_for_period
      budget.amount_in_cents - total_spending_for_period
    end

    def amount_left_per_day
      (amount_left_for_period + amount_spent_today) / days_left_in_period
    end

    def budget
      @budget ||=
        user.budgets.where(period_start:, period_end:).first
    end

    def total_spending_for_period
      user.spendings
          .where(spent_at: period_start..period_end)
          .sum(:amount_in_cents)
    end

    def amount_spent_today
      user.spendings
          .where(spent_at: Date.today.beginning_of_day..DateTime.current)
          .sum(:amount_in_cents)
    end

    def days_left_in_period
      remaining_days = (period_end.to_date - Date.today).to_i + 1

      [remaining_days, 0].max
    end

    def period_start
      budget.period_start
    end

    def period_end
      budget.period_end
    end

    attr_accessor :user, :budget
  end
end

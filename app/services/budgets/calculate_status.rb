module Budgets
  class CalculateStatus
    include Service

    BudgetStatus = Struct.new(
      :amount_spent_today,
      :amount_left_today,
      :amount_left_for_period,
      :daily_limit,
      keyword_init: true
    )

    def call
      BudgetStatus.new(
        amount_spent_today:,
        amount_left_today:,
        amount_left_for_period:,
        daily_limit:
      )
    end

    private

    def amount_left_today
      daily_limit - amount_spent_today
    end

    def amount_left_for_period
      budget.amount_cents - total_spending_for_period
    end

    def daily_limit
      (amount_left_for_period + amount_spent_today) / days_left_in_period
    end

    def budget
      @budget ||= Budgets::Find.call(user:, period_range:)
    end

    def total_spending_for_period
      user.spendings
          .where(spent_at: period_range)
          .sum(:amount_cents)
    end

    def amount_spent_today
      user.spendings
          .where(spent_at: Date.today.bod..DateTime.current)
          .sum(:amount_cents)
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

    def period_range
      period_start..period_end
    end

    attr_accessor :user, :budget
  end
end

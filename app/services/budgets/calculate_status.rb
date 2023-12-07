module Budgets
  class CalculateStatus
    include Service

    BudgetStatus = Struct.new(
      :amount_spent_today,
      :amount_recovered_today,
      :amount_left_today,
      :amount_left_period,
      :today_daily_limit,
      :remaining_daily_limit,
      :current_daily_limit,
      :adjusted_daily_limit,
      keyword_init: true
    )

    def call
      BudgetStatus.new(
        amount_spent_today:,
        amount_recovered_today:,
        amount_left_today:,
        amount_left_period:,
        today_daily_limit:,
        remaining_daily_limit:,
        current_daily_limit:,
        adjusted_daily_limit:
      )
    end

    private

    def amount_left_today
      current_daily_limit - [balance_today, 0].max
    end

    def amount_left_period
      budget.amount_cents - balance_period
    end

    def today_daily_limit
      current_daily_limit
    end

    # This is the daily limit for the rest of the period not including today
    def remaining_daily_limit
      return adjusted_daily_limit if amount_left_today.negative?

      current_daily_limit
    end

    # This is the daily limit for the rest of the period including today,
    # without taking into account today's spending
    def current_daily_limit
      (amount_left_period + balance_today) / days_left_in_period
    end

    # This is the amount left per day taking into account today's balance
    # It only counts the days after today
    def adjusted_daily_limit
      return amount_left_period if days_left_in_period <= 1

      amount_left_period / (days_left_in_period - 1)
    end

    def amount_spent_today
      @amount_spent_today ||=
        user.ledger_entries
            .spending
            .where(recorded_at: Time.zone.today.bod..DateTime.current)
            .sum(:amount_cents)
    end

    def amount_recovered_today
      @amount_recovered_today ||=
        user.ledger_entries
            .recovery
            .where(recorded_at: Time.zone.today.bod..DateTime.current)
            .sum(:amount_cents)
    end

    def balance_today
      amount_spent_today - amount_recovered_today
    end

    def amount_spent_period
      @amount_spent_period ||=
        user.ledger_entries
            .spending
            .where(recorded_at: period_range)
            .sum(:amount_cents)
    end

    def amount_recovered_period
      @amount_recovered_period ||=
      user.ledger_entries
          .recovery
          .where(recorded_at: period_range)
          .sum(:amount_cents)
    end

    def balance_period
      amount_spent_period - amount_recovered_period
    end

    def days_left_in_period
      remaining_days = (period_end.to_date - Time.zone.today).to_i + 1

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

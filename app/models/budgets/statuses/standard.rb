module Budgets
  module Statuses
    class Standard < Base
      def today_remaining_amount
        current_daily_limit - balance_today
      end

      def period_remaining_amount
        budgeted_amount - balance_period
      end

      def today_daily_limit
        current_daily_limit
      end

      # daily limit for the rest of the period not including today
      def remaining_daily_limit
        return adjusted_daily_limit if today_remaining_amount.negative?

        current_daily_limit
      end

      private

      # This is the daily limit for the rest of the period including today,
      # without taking into account today's spending
      def current_daily_limit
        (period_remaining_amount + balance_today) / days_left_in_period
      end

      # daily limit taking into account today's balance
      def adjusted_daily_limit(include_today: false)
        return period_remaining_amount if days_left_in_period <= 1

        period_remaining_amount / (days_left_in_period - (include_today ? 0 : 1))
      end
    end
  end
end

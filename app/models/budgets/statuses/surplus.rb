module Budgets
  module Statuses
    class Surplus < Base
      def today_remaining_amount
        adjusted_daily_limit
      end

      def period_remaining_amount
        budgeted_amount - balance_period
      end

      def today_daily_limit
        adjusted_daily_limit
      end

      # daily limit for the rest of the period not including today
      def remaining_daily_limit
        adjusted_daily_limit
      end

      private

      # daily limit taking into account today's surplus
      def adjusted_daily_limit
        return period_remaining_amount if days_left_in_period <= 1

        period_remaining_amount / days_left_in_period
      end
    end
  end
end

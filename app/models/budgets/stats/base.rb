module Budgets
  module Stats
    class Base
      attr_reader :today_spent_amount,
                  :today_recovered_amount,
                  :period_spent_amount,
                  :period_recovered_amount,
                  :budgeted_amount,
                  :period_range

      def initialize(today_spent_amount:,
                     today_recovered_amount:,
                     period_spent_amount:,
                     period_recovered_amount:,
                     budgeted_amount:,
                     period_range:)
        @today_spent_amount      = today_spent_amount
        @today_recovered_amount  = today_recovered_amount
        @period_spent_amount     = period_spent_amount
        @period_recovered_amount = period_recovered_amount
        @budgeted_amount         = budgeted_amount
        @period_range            = period_range
      end

      def period_surplus_amount
        [balance_period, 0].min.abs
      end

      private

      def balance_today
        today_spent_amount - today_recovered_amount
      end

      def balance_period
        period_spent_amount - period_recovered_amount
      end

      def days_left_in_period
        remaining_days = (period_end.to_date - DateTime.current.bod).to_i

        [remaining_days, 0].max
      end

      def period_end
        period_range.end
      end
    end
  end
end

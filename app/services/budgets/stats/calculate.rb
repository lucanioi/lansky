module Budgets
  module Stats
    class Calculate
      include Service

      def call
        status_class.new(
          today_spent_amount:,
          today_recovered_amount:,
          period_spent_amount:,
          period_recovered_amount:,
          budgeted_amount: budget.amount_cents,
          period_range: period_range,
        )
      end

      private

      def status_class
        return Budgets::Stats::Surplus if surplus?

        Budgets::Stats::Standard
      end

      def today_spent_amount
        @today_spent_amount ||=
          user.ledger_entries
              .spending
              .where(recorded_at: Time.zone.today.bod..DateTime.current)
              .sum(:amount_cents)
      end

      def today_recovered_amount
        @today_recovered_amount ||=
          user.ledger_entries
              .recovery
              .where(recorded_at: Time.zone.today.bod..DateTime.current)
              .sum(:amount_cents)
      end

      def period_spent_amount
        @period_spent_amount ||=
          user.ledger_entries
              .spending
              .where(recorded_at: period_range)
              .sum(:amount_cents)
      end

      def period_recovered_amount
        @period_recovered_amount ||=
        user.ledger_entries
            .recovery
            .where(recorded_at: period_range)
            .sum(:amount_cents)
      end

      def period_range
        @period_range ||= budget.period_start..budget.period_end
      end

      def surplus?
        today_recovered_amount > today_spent_amount ||
          period_recovered_amount > period_spent_amount
      end

      attr_accessor :user, :budget
    end
  end
end

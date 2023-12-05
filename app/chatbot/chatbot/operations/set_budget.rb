module Chatbot
  module Operations
    class SetBudget < BaseOperation
      params :period, :amount_in_cents

      def execute
        result = Budgets::Upsert.call(amount_in_cents:, period_start:, period_end:, user:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(budget)
        period_name = DateTimeHelper.format_period(period_range)
        formatted_amount = ::Chatbot::MoneyHelper.format(budget.amount_in_cents)

        "Budget for #{period_name} set to #{formatted_amount}"
      end

      def period_start
        period_range.begin
      end

      def period_end
        period_range.end
      end

      def period_range
        @period_range ||= DateTimeHelper.parse_period(period, direction: :forward)
      end
    end
  end
end

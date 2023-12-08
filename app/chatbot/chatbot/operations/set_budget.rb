module Chatbot
  module Operations
    class SetBudget < Base
      params :period, :amount_cents

      def run
        result = Budgets::Upsert.run(amount_cents:, period_range:, user:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(budget)
        period_name = DateTimeHelper.format_period(period_range)
        formatted_amount = ::Chatbot::MoneyHelper.format(budget.amount_cents)

        "Budget for #{period_name} set to #{formatted_amount}"
      end

      def period_range
        @period_range ||= DateTimeHelper.parse_period(period, direction: :forward)
      end
    end
  end
end

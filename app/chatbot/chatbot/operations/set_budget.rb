module Chatbot
  module Operations
    class SetBudget < Base
      params :period, :amount_cents

      def run
        result = Budgets::Upsert.run(amount_cents:, period:, user:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(budget)
        period_name = Helpers::DateTimeHelper.format_period(period)
        formatted_amount = Helpers::MoneyHelper.format(budget.amount_cents)

        "[TEST] Budget for #{period_name} set to #{formatted_amount}"
      end
    end
  end
end

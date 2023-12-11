module Chatbot
  module Operations
    class SetBudget < Base
      params :flex_date, :amount_cents

      def run
        result = Budgets::Upsert.run(amount_cents:, period:, user:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(budget)
        formatted_amount = Helpers::MoneyHelper.format(budget.amount_cents)

        "Budget for #{period.format} set to #{formatted_amount}"
      end

      def period
        flex_date&.to_period(direction: :forward)
      end
    end
  end
end

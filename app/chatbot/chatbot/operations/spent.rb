module Chatbot
  module Operations
    class Spent < Base
      params :category_name, :amount_cents

      def run
        result = LedgerEntries::CreateSpending.run(user:, amount_cents:, category_name:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(spending)
        formatted_amount = format(spending.amount_cents)

        "Spent #{formatted_amount} #{category_description(spending.category)}"
      end

      def category_description(category)
        return "(uncategorized)" if category.uncategorized?

        "on #{category.name}"
      end

      def format(amount)
        Helpers::MoneyHelper.format(amount)
      end
    end
  end
end

module Chatbot
  module Operations
    class Spent < Base
      params :category_name, :amount_cents

      def run
        result = LedgerEntries::CreateSpending.run(user:, amount_cents:, category:, )

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(spending)
        formatted_amount = format(spending.amount_cents)

        "Spent #{formatted_amount} #{category_description}"
      end

      def category_description
        return "(uncategorized)" if category.uncategorized?

        "on #{category.name}"
      end

      def category
        @category ||=
          LedgerCategories::FindOrCreate.run(name: category_name).value
      end

      def format(amount)
        ::Chatbot::MoneyHelper.format(amount)
      end
    end
  end
end

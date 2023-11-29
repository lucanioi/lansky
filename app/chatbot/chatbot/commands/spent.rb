module Chatbot
  module Commands
    class Spent < BaseCommand
      params :amount_in_cents, :category_name

      def execute
        result = Spendings::Create.call(category:, amount_in_cents:, user:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(spending)
        formatted_amount = format(spending.amount_in_cents)

        "Spent #{formatted_amount} #{category_description}"
      end

      def category_description
        return "(uncategorized)" if category.uncategorized?

        "on #{category.name}"
      end

      def category
        @category ||=
          SpendingCategories::FindOrCreate.call(name: category_name).value
      end

      def format(amount)
        ::Chatbot::MoneyHelper.format_euros_with_cents(amount)
      end
    end
  end
end

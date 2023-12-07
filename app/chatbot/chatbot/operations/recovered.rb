module Chatbot
  module Operations
    class Recovered < BaseOperation
      params :amount_cents, :category_name

      def execute
        result = LedgerEntries::CreateRecovery.call(user:, amount_cents:, category:, )

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(recovery)
        formatted_amount = format(recovery.amount_cents)

        "Recovered #{formatted_amount} (#{category.name})"
      end

      def category
        @category ||=
          LedgerCategories::FindOrCreate.call(name: category_name).value
      end

      def format(amount)
        ::Chatbot::MoneyHelper.format(amount)
      end
    end
  end
end
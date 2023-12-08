module Chatbot
  module Operations
    class Recovered < Base
      params :category_name, :amount_cents

      def run
        result = LedgerEntries::CreateRecovery.run(user:, amount_cents:, category:, )

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
          LedgerCategories::FindOrCreate.run(name: category_name).value
      end

      def format(amount)
        Helpers::MoneyHelper.format(amount)
      end
    end
  end
end

module Chatbot
  module Operations
    class Recovered < Base
      params :category_name, :amount_cents

      def run
        result = LedgerEntries::CreateRecovery.run(user:, amount_cents:, category_name:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(recovery)
        formatted_amount = format(recovery.amount_cents)

        "Recovered #{formatted_amount} (#{recovery.category.name})"
      end

      def format(amount)
        Helpers::MoneyHelper.format(amount)
      end
    end
  end
end

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

      def validate_params!
        unless flex_date.is_a?(Lansky::FlexibleDate)
          raise InvalidParameter, "Invalid flex_date: #{flex_date.inspect}"
        end

        unless amount_cents.is_a?(Integer)
          raise InvalidParameter, "Invalid amount_cents: #{amount_cents.inspect}"
        end
      end
    end
  end
end

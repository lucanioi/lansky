module Chatbot
  module Operations
    class GetBudget < Base
      params :flex_date

      def run
        result = Budgets::Find.run(user:, period:)

        raise result.error if result.failure?
        return not_found_reply if result.value.nil?

        reply(result.value)
      end

      private

      def not_found_reply
        if period.present?
          "No budget set for #{period_title}"
        else
          'No active budget found'
        end
      end

      def reply(budget)
        formatted_amount = Helpers::MoneyHelper.format(budget.amount_cents)

        "Budget for #{period_title(budget)} is #{formatted_amount}"
      end

      def period_title(budget = nil)
        return nil unless budget || period
        return period.format if period.present?

        period = Lansky::Period.new(budget.period_start, budget.period_end)
        period.format
      end

      def period
        flex_date&.to_period
      end

      def validate_params!
        return if flex_date.is_a? Lansky::FlexibleDate

        raise InvalidParameter, "Invalid flex_date: #{flex_date.inspect}"
      end
    end
  end
end

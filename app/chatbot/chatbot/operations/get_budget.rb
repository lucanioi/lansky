module Chatbot
  module Operations
    class GetBudget < Base
      params :period

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
        return Helpers::DateTimeHelper.format_period(period) if period.present?

        period = Period.new(budget.period_start, budget.period_end)

        Helpers::DateTimeHelper.format_period(period)
      end
    end
  end
end

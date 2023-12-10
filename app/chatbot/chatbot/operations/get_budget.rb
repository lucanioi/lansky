module Chatbot
  module Operations
    class GetBudget < Base
      params :period

      def run
        result = Budgets::Find.run(user:, period_range:)

        raise result.error if result.failure?
        return not_found_reply if result.value.nil?

        reply(result.value)
      end

      private

      def not_found_reply
        if period_range.present?
          "No budget set for #{period_title}"
        else
          'No active budget found'
        end
      end

      def reply(budget)
        formatted_amount = Helpers::MoneyHelper.format(budget.amount_cents)

        "Budget for #{period_title(budget)} is #{formatted_amount}"
      end

      def period_range
        period.range unless period.blank?
      end

      def period_title(budget = nil)
        return nil unless budget || period_range
        return Helpers::DateTimeHelper.format_period(period_range) if period_range.present?

        range = budget.period_start..budget.period_end
        Helpers::DateTimeHelper.format_period(range)
      end
    end
  end
end

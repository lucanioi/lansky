module Chatbot
  module Operations
    class GetBudget < BaseOperation
      params :period

      def execute
        result = Budgets::Find.call(user:, period_range:)

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
        formatted_amount = ::Chatbot::MoneyHelper.format(budget.amount_cents)

        "Budget for #{period_title(budget)} is #{formatted_amount}"
      end

      def period_range
        return if period.blank?

        @period_range ||=
          DateTimeHelper.parse_period(period, include_current: true)
      end

      def period_title(budget = nil)
        return nil unless budget || period_range
        return DateTimeHelper.format_period(period_range) if period_range.present?

        range = budget.period_start..budget.period_end
        DateTimeHelper.format_period(range)
      end
    end
  end
end

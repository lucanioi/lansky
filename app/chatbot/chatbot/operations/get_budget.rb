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
        "No budget set for #{period_title}"
      end

      def reply(budget)
        formatted_amount = ::Chatbot::MoneyHelper.format(budget.amount_in_cents)

        "Budget for #{period_title} is #{formatted_amount}"
      end

      def period_range
        @period_range ||=
          DateTimeHelper.parse_period(period, include_current: true)
      end

      def period_title
        @period_title ||=
          DateTimeHelper.format_period(period_range)
      end
    end
  end
end

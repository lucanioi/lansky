module Chatbot
  module Operations
    class Spending < BaseOperation
      params :period

      def execute
        result = Spendings::Overview.call(
          user:,
          period_start: period_range.begin,
          period_end: period_range.end
        )

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def period_range
        @period_range ||= DateTimeHelper.parse_period(period)
      end
    end
  end
end

module Chatbot
  module Operations
    class Spending < BaseOperation
      params :period

      def execute
        result = Spendings::Overview.call(user:, period_start:, period_end:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def period_range
        case period
        when 'this month'
          Date.today.beginning_of_month..Date.today.end_of_month
        when 'last month'
          Date.today.prev_month.beginning_of_month..Date.today.prev_month.end_of_month
        when 'today'
          Date.today.beginning_of_day..Date.today.end_of_day
        when 'yesterday'
          Date.yesterday.beginning_of_day..Date.yesterday.end_of_day
        when nil then (raise 'invalid period')
        end

        parse_month
      end
    end
  end
end

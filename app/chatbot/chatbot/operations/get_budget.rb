module Chatbot
  module Operations
    class GetBudget < BaseOperation
      params :month

      def execute
        result = Budgets::Find.call(
          period_start: period_start,
          period_end: period_end,
          user: user
        )

        raise result.error if result.failure?
        return not_found_reply if result.value.nil?

        reply(result.value)
      end

      private

      def not_found_reply
        "No budget set for #{Date::MONTHNAMES[period_start.month]}"
      end

      def reply(budget)
        month = Date::MONTHNAMES[budget.period_start.month]
        formatted_amount = ::Chatbot::MoneyHelper.format_euros(budget.amount_in_cents)

        "Budget for #{month} is #{formatted_amount}"
      end

      def period_start
        case month
        when 'this month' then return Date.today.bom
        when 'next month' then return Date.today.next_month.bom
        when nil then (raise 'invalid month')
        end

        parse_month
      end

      def period_end
        period_start.end_of_month
      end

      def parse_month
        # if month is before current month, then set it for next year
        numerical_month = Date::MONTHNAMES.index(month.capitalize)
        year = numerical_month < Date.today.month ? Date.today.year + 1 : Date.today.year
        Date.new(year, numerical_month)
      end
    end
  end
end

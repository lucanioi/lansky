module Chatbot
  module Commands
    class SetBudget < BaseCommand
      attr_reader :message, :params
      delegate :month, :amount_in_cents, to: :params

      def initialize(message)
        @message = message
        @params = Chatbot::Parsers::SetBudget.new(message)
      end

      def execute
        result = Budgets::Upsert.call(amount_in_cents:, period_start:, period_end:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(budget)
        month = Date::MONTHNAMES[budget.period_start.month]
        formatted_amount = ::Chatbot::MoneyHelper.format_euros(budget.amount_in_cents)

        "Budget for #{month} set to #{formatted_amount}"
      end

      def period_start
        case month
        when 'this month' then return Date.today.beginning_of_month
        when 'next month' then return Date.today.next_month.beginning_of_month
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

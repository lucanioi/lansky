module ChatBot
  module Commands
    class SetBudget
      include Service
      include MoneyHelper

      VALID_MONTHS = Date::MONTHNAMES.compact + ['this month', 'next month']

      def call
        result = Budgets::Create.call(amount_in_cents:, period_start:, period_end:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(budget)
        month = Date::MONTHNAMES[budget.period_start.month]

        "Budget for #{month} set to #{format_euros(budget.amount_in_cents)}."
      end

      def amount_in_cents
        extract_amount(argument)
      end

      def period_start
        case month_argument
        when 'this month' then Date.today.beginning_of_month
        when 'next month' then Date.today.next_month.beginning_of_month
        when nil then (raise 'Invalid month')
        else
          # if month is before current month, then set it for next year
          numerical_month = Date::MONTHNAMES.index(month_argument)
          year = numerical_month < Date.today.month ? Date.today.year + 1 : Date.today.year
          Date.new(year, numerical_month)
        end
      end

      def period_end
        period_start.end_of_month
      end

      def argument
        body.delete_prefix('set budget ')
      end

      def month_argument
        VALID_MONTHS.find { |month| body.downcase.include?(month.downcase) }
      end

      attr_accessor :body
    end
  end
end

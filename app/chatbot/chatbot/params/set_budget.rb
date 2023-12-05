module Chatbot
  module Params
    class SetBudget < BaseParams
      VALID_MONTHS = Date::MONTHNAMES.compact + ['this month', 'next month']

      def period
        @month ||= extract_period
      end

      def amount_in_cents
        @amount_in_cents ||= extract_amount
      end

      private

      def extract_period
        VALID_MONTHS.find do |month|
          argument.include?(month.downcase)
        end&.downcase || (raise 'invalid month')
      end

      def extract_amount
        amount = argument.split(' ')[-1].strip
        ::Chatbot::MoneyHelper.parse_amount(amount) || (raise 'invalid amount')
      end

      def period_end
        period_start.eom
      end

      def argument
        message.delete_prefix('set budget ').strip.downcase
      end
    end
  end
end

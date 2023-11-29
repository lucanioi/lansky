module Chatbot
  module Params
    class SetBudget
      attr_reader :month, :amount_in_cents

      VALID_MONTHS = Date::MONTHNAMES.compact + ['this month', 'next month']

      def initialize(message)
        @message = message
        extract
      end

      private

      attr_reader :message

      def extract
        @month = extract_month
        @amount_in_cents = extract_amount
      end

      def period_end
        period_start.end_of_month
      end

      def argument
        message.delete_prefix('set budget ')
      end

      def extract_month
        VALID_MONTHS.find do |month|
          argument.downcase.include?(month.downcase)
        end || (raise 'invalid month')
      end

      def extract_amount
        amount = argument.split(' ')[-1].strip
        ::Chatbot::MoneyHelper.parse_amount(amount) || (raise 'invalid amount')
      end
    end
  end
end

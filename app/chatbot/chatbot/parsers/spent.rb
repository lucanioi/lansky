module Chatbot
  module Parsers
    class Spent
      attr_reader :category_name, :amount_in_cents

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
        ::Chatbot::MoneyHelper.extract_amount(argument) || (raise 'invalid amount')
      end
    end
  end
end

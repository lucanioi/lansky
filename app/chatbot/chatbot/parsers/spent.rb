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
        @category_name = extract_category_name
        @amount_in_cents = extract_amount
      end

      def period_end
        period_start.end_of_month
      end

      def argument
        message.delete_prefix('spent ')
      end

      def extract_category_name
        argument.split(' ')[1..-1].join(' ').presence || 'uncategorized'
      end

      def extract_amount
        ::Chatbot::MoneyHelper.parse_amount(argument) || (raise 'invalid amount')
      end
    end
  end
end

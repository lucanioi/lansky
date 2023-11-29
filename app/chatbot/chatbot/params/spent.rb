module Chatbot
  module Params
    class Spent < BaseParams
      def category_name
        @category_name ||= extract_category_name
      end

      def amount_in_cents
        @amount_in_cents ||= extract_amount
      end

      private

      def period_end
        period_start.end_of_month
      end

      def argument
        message.delete_prefix('spent ')
      end

      def extract_category_name
        argument.split(' ')[1..-1].join(' ').presence
      end

      def extract_amount
        amount = argument.split(' ')[0]
        ::Chatbot::MoneyHelper.parse_amount(amount) || (raise 'invalid amount')
      end
    end
  end
end

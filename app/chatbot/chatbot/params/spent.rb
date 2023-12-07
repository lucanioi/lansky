module Chatbot
  module Params
    class Spent < BaseParams
      def category_name
        @category_name ||= extract_category_name
      end

      def amount_cents
        @amount_cents ||= extract_amount
      end

      private

      def extract_category_name
        argument.split(' ')[1..-1].join(' ').presence
      end

      def extract_amount
        amount = argument.split(' ')[0]
        ::Chatbot::MoneyHelper.parse_amount(amount)&.abs || (raise 'invalid amount')
      end

      def argument
        message.delete_prefix('spent ').strip
      end
    end
  end
end

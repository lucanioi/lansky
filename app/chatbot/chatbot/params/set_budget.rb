module Chatbot
  module Params
    class SetBudget < BaseParams
      def period
        @month ||= extract_period
      end

      def amount_in_cents
        @amount_in_cents ||= extract_amount
      end

      private

      def extract_period
        argument.split(' ')[0..-2].join(' ')
      end

      def extract_amount
        amount = argument.split(' ')[-1].strip
        ::Chatbot::MoneyHelper.parse_amount(amount) || (raise 'invalid amount')
      end

      def argument
        message.delete_prefix('set budget').strip.downcase
      end
    end
  end
end

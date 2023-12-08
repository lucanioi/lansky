module Chatbot
  module Params
    class SetBudget < BaseParams
      def to_h
        { period:, amount_cents: }
      end

      private

      def period
        argument.split(' ')[0..-2].join(' ')
      end

      def amount_cents
        amount = argument.split(' ')[-1].strip
        ::Chatbot::MoneyHelper.parse_amount(amount) || (raise 'invalid amount')
      end

      def argument
        message.delete_prefix('set budget').strip.downcase
      end
    end
  end
end

require_relative 'errors'

module Chatbot
  module Params
    class Spent < BaseParams
      def to_h
        { category_name:, amount_cents: }
      end

      private

      def category_name
        argument.split(' ')[1..-1].join(' ').presence
      end

      def amount_cents
        amount = argument.split(' ')[0]
        amount = ::Chatbot::MoneyHelper.parse_amount(amount)&.abs

        amount || raise(Params::InvalidAmount, "Invalid amount: #{argument}")
      end

      def argument
        message.delete_prefix('spent ').strip
      end
    end
  end
end

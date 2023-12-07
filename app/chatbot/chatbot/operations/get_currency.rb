module Chatbot
  module Operations
    class GetCurrency < BaseOperation
      def execute
        "Currency: #{currency}"
      end

      private

      def currency
        user.currency || Money.default_currency
      end
    end
  end
end

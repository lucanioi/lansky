module Chatbot
  module Operations
    class GetCurrency < BaseOperation
      def execute
        "Your current currency setting is #{currency}"
      end

      private

      def currency
        user.currency || Money.default_currency
      end
    end
  end
end

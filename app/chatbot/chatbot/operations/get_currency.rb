module Chatbot
  module Operations
    class GetCurrency < Base
      def run
        "Currency: #{currency}"
      end

      private

      def currency
        user.currency || Money.default_currency
      end
    end
  end
end

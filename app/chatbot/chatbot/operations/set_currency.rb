module Chatbot
  module Operations
    class SetCurrency < BaseOperation
      params :currency

      def execute
        return 'you need to specify a currency' unless currency.present?
        return "invalid currency: #{currency}" unless normalized_currency

        result = Users::Update.call(user:, params: update_params)

        return reply if result.success?

        raise result.error
      end

      private

      def reply
        "Currency set to #{normalized_currency}"
      end

      def update_params
        {
          currency: normalized_currency
        }
      end

      def normalized_currency
        @normalized_currency ||= Money::Currency.find(currency.upcase)&.iso_code
      end
    end
  end
end

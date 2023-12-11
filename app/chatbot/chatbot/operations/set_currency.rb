module Chatbot
  module Operations
    class SetCurrency < Base
      params :currency

      def run
        return 'you need to specify a currency' unless currency.present?
        return "invalid currency: #{currency}" unless normalized_currency

        result = Users::Update.run(user:, params: update_params)

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

      def validate_params!
        return if currency.is_a?(String)

        raise InvalidParameter, "Invalid currency: #{currency.inspect}"
      end
    end
  end
end

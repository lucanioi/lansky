module Chatbot
  module Params
    class SetCurrency < BaseParams
      def currency
        @period ||= extract_currency
      end

      private

      def extract_currency
        argument.strip.downcase
      end

      def argument
        message.delete_prefix('set currency')
      end
    end
  end
end

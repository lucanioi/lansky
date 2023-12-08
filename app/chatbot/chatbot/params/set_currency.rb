module Chatbot
  module Params
    class SetCurrency < BaseParams
      def to_h
        { currency: }
      end

      private

      def currency
        argument.strip.downcase
      end

      def argument
        message.delete_prefix('set currency')
      end
    end
  end
end

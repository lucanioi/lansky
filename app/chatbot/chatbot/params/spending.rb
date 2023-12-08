module Chatbot
  module Params
    class Spending < BaseParams
      def to_h
        { period: }
      end

      private

      def period
        argument.downcase
      end

      def argument
        message.delete_prefix('spending').strip
      end
    end
  end
end

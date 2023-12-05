module Chatbot
  module Params
    class Spending < BaseParams
      def period
        @period ||= extract_period
      end

      private

      def extract_period
        argument
      end

      def argument
        message.delete_prefix('spending ').strip
      end
    end
  end
end

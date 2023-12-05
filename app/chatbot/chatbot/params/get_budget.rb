module Chatbot
  module Params
    class GetBudget < BaseParams
      def period
        @month ||= extract_period
      end

      private

      def extract_period
        argument
      end

      def argument
        message.delete_prefix('get ').delete_prefix('budget ').strip.downcase
      end
    end
  end
end

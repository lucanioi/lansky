module Chatbot
  module Params
    class SetTimezone < BaseParams
      def timezone
        @timezone ||= extract_timezone
      end

      private

      def extract_timezone
        argument
      end

      def argument
        message.delete_prefix('set').strip.delete_prefix('timezone').strip
      end
    end
  end
end

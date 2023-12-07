module Chatbot
  module Params
    class SetTimezone < BaseParams
      def timezone_name
        @timezone ||= extract_timezone_name
      end

      private

      def extract_timezone_name
        argument
      end

      def argument
        message.delete_prefix('set').strip.delete_prefix('timezone').strip
      end
    end
  end
end

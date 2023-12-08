module Chatbot
  module Params
    class SetTimezone < BaseParams
      def to_h
        { timezone_name: }
      end

      private

      def timezone_name
        argument
      end

      def argument
        message.delete_prefix('set').strip.delete_prefix('timezone').strip
      end
    end
  end
end

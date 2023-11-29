module Chatbot
  module Params
    class BaseParams
      def initialize(message)
        @message = message
      end

      private

      attr_reader :message
    end
  end
end

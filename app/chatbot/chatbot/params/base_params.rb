module Chatbot
  module Params
    class BaseParams
      def initialize(message)
        @message = message
      end

      def to_h
        raise NotImplementedError
      end

      private

      attr_reader :message
    end
  end
end

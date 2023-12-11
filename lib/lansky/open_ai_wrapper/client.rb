module Lansky
  module OpenAIWrapper
    class Client
      attr_reader :input, :ai

      def initialize
        @ai = ::OpenAI::Client.new
      end

      def parse_operation(input:)
        FunctionCall.run(input:, ai:).value!
      end
    end
  end
end

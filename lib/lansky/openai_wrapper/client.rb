module Lansky
  module OpenAIWrapper
    class Client
      attr_reader :input, :client

      def initialize(input)
        @input  = input
        @client = ::OpenAI::Client.new
      end

      def function_call
        FunctionCall.new(input, client).call
      end
    end
  end
end

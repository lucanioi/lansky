module Lansky
  module OpenAIWrapper
    class Client
      attr_reader :input, :ai

      def initialize
        @ai = ::OpenAI::Client.new
      end

      def parse_operation(input:)
        FunctionCall.run(input:, ai:).value!.tap do |result|
          puts "OpenAI response from `function_calls`: #{result}" if verbose?
        end
      end

      def verbose?
        ENV['VERBOSE'] == 'true'
      end
    end
  end
end

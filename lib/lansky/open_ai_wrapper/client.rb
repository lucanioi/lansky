module Lansky
  module OpenAIWrapper
    class Client
      attr_reader :input, :ai, :prompts

      def initialize(prompts:)
        @ai = ::OpenAI::Client.new
        @prompts = prompts
      end

      def parse_operation(input:)
        puts "OpenAI request to `function_calls`: #{input}" if verbose?

        result = FunctionCall.run(input:, ai:, functions: prompts[:operations])
        result.value!.tap do |result|
          puts "OpenAI response from `function_calls`: #{result}" if verbose?
        end
      end

      private

      def verbose?
        ENV['VERBOSE'] == 'true'
      end
    end
  end
end

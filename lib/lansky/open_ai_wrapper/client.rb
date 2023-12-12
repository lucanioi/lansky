module Lansky
  module OpenAIWrapper
    class Client
      attr_reader :ai, :prompts

      def initialize(prompts:)
        @ai = ::OpenAI::Client.new
        @prompts = prompts
      end

      def parse_operation(input:)
        verbose(input) do
          functions = prompts[:operations]
          FunctionCall.run(input:, ai:, functions:).value!
        end
      end

      private

      def verbose?
        ENV['VERBOSE'] == 'true' && !Rails.env.production?
      end

      def verbose(input, &block)
        return block.call unless verbose?

        puts "input to `function_calls`:".green
        puts "#{input}\n".light_green

        result = block.call

        puts "OpenAI response:".green
        puts "#{format_result(result)}\n\n".light_green

        result
      end

      def format_result(result)
        return if result.nil?

        result.deep_stringify_keys.to_yaml.gsub('---', '').strip
      end
    end
  end
end

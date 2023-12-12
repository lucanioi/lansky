module Lansky
  module OpenAIWrapper
    class Client
      attr_reader :ai, :prompts

      def initialize(prompts:)
        @ai = ::OpenAI::Client.new
        @prompts = prompts
      end

      def parse_operation(input:)
        verbose(input, 'function_calls') do
          functions = prompts[:operations]
          FunctionCall.run(input:, ai:, functions:).value!
        end
      end

      def generate_response(input:)
        verbose(input, 'text generation') do
          TextGeneration.run(input:, ai:).value!
        end
      end

      private

      def verbose(input, type, &block)
        return block.call unless verbose?

        puts "input to `#{type}`:".green
        puts "#{input}\n".light_green

        result = block.call

        puts "OpenAI response:".green
        puts "#{format_result(result)}\n\n".light_green

        result
      end

      def format_result(result)
        return if result.nil?
        return result if result.is_a? String

        return unless result.is_a? Hash
        result.deep_stringify_keys.to_yaml.gsub('---', '').strip
      end

      def verbose?
        ENV['VERBOSE'] == 'true' && !Rails.env.production?
      end
    end
  end
end

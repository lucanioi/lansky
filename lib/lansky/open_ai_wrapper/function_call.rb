require_relative '../../runnable'

module Lansky
  module OpenAIWrapper
    class FunctionCall
      include Runnable

      def run
        response = ai.chat(parameters:)

        message = response.dig('choices', 0, 'message')

        return unless message['role'] == 'assistant' && message['function_call']

        operation = message.dig('function_call', 'name')
        args = JSON.parse(message.dig('function_call', 'arguments'), { symbolize_names: true })

        { operation:, args: }
      end

      private

      def parameters
        {
          model: config.function_calls.model,
          messages: [
            {
              'role': 'user',
              'content': input_with_metadata,
            },
          ],
          functions:,
        }
      end

      def input_with_metadata
        "#{input}\n\n" \
        "<METADATA>\n " \
        "current date: #{DateTime.current.to_date}"
      end

      def config
        @config ||= Config.new
      end

      attr_accessor :input, :ai, :functions
    end
  end
end

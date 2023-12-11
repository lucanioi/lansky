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
          model: 'gpt-3.5-turbo-1106',
          messages: [
            {
              'role': 'user',
              'content': input,
            },
          ],
          functions:,
        }
      end

      attr_accessor :input, :ai, :functions
    end
  end
end

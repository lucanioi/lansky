require_relative '../../runnable'

module Lansky
  module OpenAIWrapper
    class TextGeneration
      include Runnable

      def run
        response = ai.chat(parameters:)

        message = response.dig('choices', 0, 'message')

        return unless message['role'] == 'assistant' && message['content']

        message['content']
      end

      private

      def parameters
        {
          model: config.text_generation.model,
          messages: [
            {
              'role': 'user',
              'content': input,
            },
          ],
        }
      end

      def config
        @config ||= Config.new
      end

      attr_accessor :input, :ai
    end
  end
end

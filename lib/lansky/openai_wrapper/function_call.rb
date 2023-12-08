module Lansky
  module OpenAIWrapper
    class FunctionCall
      attr_reader :input, :client

      def initialize(input, client)
        @input  = input
        @client = client
      end

      def call
        response = client.chat(parameters:)
        message = response.dig('choices', 0, 'message')

        return unless message['role'] == 'assistant' && message['function_call']

        operation = message.dig('function_call', 'name')
        args = JSON.parse(message.dig('function_call', 'arguments'), { symbolize_names: true })

        { operation:, args: }
      end

      def parameters
        {
          model: 'gpt-3.5-turbo-1106',
          messages: [
            {
              'role': 'user',
              'content': input,
            },
          ],
          functions: [
            register_spending_function,
            get_budget_function,
          ]
        }
      end

      def register_spending_function
        {
          name: 'register_spending',
          description: 'Register the user\'s spending with categories',
          parameters: {
            type: :object,
            properties: {
              amount_cents: {
                type: :string,
                description: <<~DESC.strip,
                  The amount of money spent. Example: 10.00, 10, 10.5, etc.
                  Always positive. 10 euros should be represented as 1000.
                  However, some currencies without fractional cents (like JPY)
                  should be represented as 10.
                DESC
              },
              category: {
                type: :string,
                description: <<~DESC.strip,
                  Whatever category the user wants to use. Example: food,
                  groceries, rent, Meggie's Bday Party, etc. When unclear,
                  do not hesitate to make it null. The language of the input
                  must be preserved.
                DESC
              },
            },
            required: ['amount_cents'],
          },
        }
      end

      def get_budget_function

      end
    end
  end
end

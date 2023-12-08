module Lansky
  module OpenAIWrapper
    class FunctionCall
      attr_reader :input, :client

      def initialize(input, client)
        @input  = input
        @client = client
      end

      def run
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
            spent_function,
            get_budget_function,
          ]
        }
      end

      def spent_function
        {
          name: 'spent',
          description: 'Register the user\'s spending with categories',
          parameters: {
            type: :object,
            properties: {
              amount_cents: {
                type: :integer,
                description: <<~DESC.strip,
                  The amount of money spent. Example: 10.00, 10, 10.5, etc.
                  Always positive. 10 euros should be represented as 1000.
                  However, some currencies without fractional cents (like JPY)
                  should be represented as 10.
                  It's crucial that you get this right,
                  otherwise I might lose my job. Please be careful.
                DESC
              },
              category: {
                type: :string,
                description: <<~DESC.strip,
                  Whatever category the user wants to use. Example: food,
                  groceries, rent, Meggie's Bday Party, etc. When unclear,
                  do not hesitate to make it null. The language of the input
                  must be preserved.
                  It's crucial that you get this right,
                  otherwise I might lose my job. Please be careful.
                DESC
              },
            },
            required: ['amount_cents'],
          },
        }
      end

      def get_budget_function
        {
          name: 'get_budget',
          description: 'Returns the user\'s budget for the given period.',
          parameters: {
            type: :object,
            properties: {
              day: {
                type: :string,
                description: <<~DESC.strip,
                  ONLY the values below are accepted.
                  It is strictly forbidden to use any other values.
                  It's crucial that you get this right,
                  otherwise I might lose my job. Please be careful.
                  Return null if no obvious day is indicated.
                DESC
                enum: [
                  ['today', 'yesterday', 'tomorrow'],
                  (1..31).to_a.map(&:to_s),
                  day_names,
                  ['this ', 'last ', 'next '].product(day_names).map(&:join),
                ].flatten,
              },
              week: {
                type: :string,
                description: <<~DESC.strip,
                  ONLY the values below are accepted.
                  It is strictly forbidden to use any other values.
                  It's crucial that you get this right,
                  otherwise I might lose my job. Please be careful.
                  Return null if no obvious day is indicated.
                DESC
                enum: [
                  'this week', 'last week', 'next week',
                  '1', '2', '3', '4'
                ]
              },
              month: {
                type: :string,
                description: <<~DESC.strip,
                  ONLY the values below are accepted.
                  It is strictly forbidden to use any other values.
                  It's crucial that you get this right,
                  otherwise I might lose my job. Please be careful.
                  Return null if no obvious day is indicated.
                DESC
                enum: [
                  ['this month', 'last month', 'next month'],
                  (1..12).to_a.map(&:to_s),
                  month_names,
                  ['this ', 'last ', 'next '].product(month_names).map(&:join),
                ].flatten,
              },
              year: {
                type: :string,
                description: <<~DESC.strip,
                  Any of the values listed under "enums" are accepted.
                  Year numbers are accepted (2020, 2021, etc.)
                  It is very important that you get this right,
                  otherwise I might lose my job. Please be careful.
                  Return null if no obvious day is indicated.
                DESC
                enum: [
                  ['this year', 'last year', 'next year'],
                ].flatten,
              },
            },
            required: [],
          },
        }
      end

      def day_names
        Date::DAYNAMES.map(&:downcase)
      end

      def month_names
        Date::MONTHNAMES.compact.map(&:downcase)
      end
    end
  end
end

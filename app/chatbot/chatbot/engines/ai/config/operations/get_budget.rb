module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          class GetBudget
            DAY_NAMES = %w[sun mon tue wed thu fri sat].freeze
            MONTH_NAMES = %w[jan feb mar apr may jun jul aug sep oct nov dec]

            PROMPTS = {
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
                      DAY_NAMES,
                      ['prev ', 'this ', 'next '].product(DAY_NAMES).map(&:join),
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
                      'prev week', 'this week', 'next week',
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
                      ['prev month', 'this month', 'next month'],
                      MONTH_NAMES,
                      ['prev ', 'this ', 'next '].product(MONTH_NAMES).map(&:join),
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
                      ['prev year', 'this year', 'next year'],
                    ].flatten,
                  },
                },
                required: [],
              },
            }
          end
        end
      end
    end
  end
end

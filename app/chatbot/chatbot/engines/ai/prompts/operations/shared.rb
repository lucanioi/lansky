module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          module Shared
            VERY_IMPORTANT_MESSAGE = <<~DESC.strip.freeze
              It's crucial that you get this right,
              otherwise I might lose my job. Please be careful.
              Thank you, I appreciate your work greatly.
            DESC

            ONLY_ACCEPTED_VALUES = <<~DESC.strip.freeze
              ONLY the values below are accepted.
              It is strictly forbidden to use any other values.
              Return null if no obvious day is indicated.
            DESC

            CENTS = <<~DESC.strip.freeze
              Example input: €10.00, 10, 10.0, $10, -10, etc.
              Always positive. 10 euros should be represented as 1000.
              You could assume that the user never puts cents values unless explicitly named (like 50 cents).
              However, some currencies without fractional cents (like JPY) should be transformed to 10 if given '10' as input.
            DESC

            PARAM_NAME = 'The name of this parameter is "%s"'.freeze

            DAY_NAMES = %w[sun mon tue wed thu fri sat].freeze
            MONTH_NAMES = %w[jan feb mar apr may jun jul aug sep oct nov dec].freeze

            DATE = {
              type: :object,
              description: 'Date object which contains the day, week, month and year.',
              properties: {
                day: {
                  type: :string,
                  description: [
                    Shared::PARAM_NAME % :day,
                    ONLY_ACCEPTED_VALUES,
                    VERY_IMPORTANT_MESSAGE
                  ].join("\n"),
                  enum: [
                    ['today', 'yesterday', 'tomorrow'],
                    (1..31).to_a.map(&:to_s),
                    DAY_NAMES,
                    ['prev ', 'this ', 'next '].product(DAY_NAMES).map(&:join),
                  ].flatten,
                },
                week: {
                  type: :string,
                  description: [
                    Shared::PARAM_NAME % :week,
                    ONLY_ACCEPTED_VALUES,
                    VERY_IMPORTANT_MESSAGE
                  ].join("\n"),
                  enum: [
                    'prev week', 'this week', 'next week',
                    '1', '2', '3', '4'
                  ]
                },
                month: {
                  type: :string,
                  description: [
                    Shared::PARAM_NAME % :month,
                    ONLY_ACCEPTED_VALUES,
                    VERY_IMPORTANT_MESSAGE
                  ].join("\n"),
                  enum: [
                    ['prev month', 'this month', 'next month'],
                    MONTH_NAMES,
                    ['prev ', 'this ', 'next '].product(MONTH_NAMES).map(&:join),
                  ].flatten,
                },
                year: {
                  type: :string,
                  description: <<~DESC.strip,
                    #{Shared::PARAM_NAME % :year}
                    Any of the values listed under "enums" are accepted.
                    Year numbers are accepted (2020, 2021, etc.)
                    Return null if no obvious day is indicated.
                    #{VERY_IMPORTANT_MESSAGE}
                  DESC
                  enum: [
                    ['prev year', 'this year', 'next year'],
                  ].flatten,
                },
              },
            }
          end
        end
      end
    end
  end
end


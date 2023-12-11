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
                  date: Shared::DATE,
                },
              },
            }
          end
        end
      end
    end
  end
end

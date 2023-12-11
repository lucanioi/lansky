module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          class GetBudget
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

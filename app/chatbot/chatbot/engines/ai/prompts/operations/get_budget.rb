module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          module GetBudget
            PROMPT = {
              name: 'get_budget',
              description: <<~DESC.strip,
                [Get Budget] Get the user\'s budget for the specified date period.
                If no date is specified, then leave it empty.
              DESC
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

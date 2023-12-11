module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          class SetBudget
            PROMPTS = {
              name: 'set_budget',
              description: 'Sets the user\'s budget for the given period.',
              parameters: {
                type: :object,
                properties: {
                  date: Shared::DATE,
                },
                amount_cents: {
                  type: :integer,
                  description: <<~DESC.strip,
                    The budget to be set in cents.
                    #{Shared::CENTS}
                    #{Shared::VERY_IMPORTANT_MESSAGE}
                  DESC
                }
              },
            }
          end
        end
      end
    end
  end
end

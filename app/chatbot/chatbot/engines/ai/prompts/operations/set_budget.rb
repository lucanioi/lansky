module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          class SetBudget
            PROMPTS = {
              name: 'set_budget',
              description: '[Set Budget] Sets the user\'s budget for the given period.',
              parameters: {
                type: :object,
                properties: {
                  date: Shared::DATE,
                },
                amount_cents: {
                  type: :integer,
                  description: <<~DESC.strip,
                  The amount to be set in cents.
                    #{Shared::PARAM_NAME % :amount_cents}
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

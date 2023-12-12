module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          module Spending
            PROMPT = {
              name: 'spending',
              description: <<~DESC.strip,
                [Spending] Returns a breakdown of the user's spending in the given time period.
                It will include:
                - Total spent in period
                - Break down of spending per category

                This is function is SPENDING focused.
                DESC
              parameters: {
                type: :object,
                properties: {
                  date: Shared::DATE,
                },
                required: ['date'],
              },
            }
          end
        end
      end
    end
  end
end

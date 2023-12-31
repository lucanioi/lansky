module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          module Status
            PROMPT = {
              name: 'status',
              description: <<~DESC.strip,
                [Status] Returns an overview of the status of the current budget.
                It will include:
                - How much money is left for the day
                - How much money is left for the period
                - How much money has been spent for the day
                - How much money per day is left for the period

                This is function is BUDGETING focused.

                Currently the period defaults to the current month,
                so there's no need to specify the date.
                #{Shared::VERY_IMPORTANT_MESSAGE}
              DESC
              parameters: {
                type: :object,
                properties: {},
              },
            }
          end
        end
      end
    end
  end
end

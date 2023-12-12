module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          class GetCurrency
            PROMPTS = {
              name: 'get_currency',
              description: <<~DESC.strip,
                [Get Currency] Returns the user\'s currency
                This currency is used to register and display amounts of money.
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

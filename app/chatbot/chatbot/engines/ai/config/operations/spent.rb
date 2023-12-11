module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          class Spent
            PROMPTS = {
              name: 'spent',
              description: 'Register the user\'s spending with categories',
              parameters: {
                type: :object,
                properties: {
                  amount_cents: {
                    type: :integer,
                    description: <<~DESC.strip,
                      The amount of money spent. Example: 10.00, 10, 10.5, etc.
                      Always positive. 10 euros should be represented as 1000.
                      However, some currencies without fractional cents (like JPY)
                      should be represented as 10.
                      It's crucial that you get this right,
                      otherwise I might lose my job. Please be careful.
                    DESC
                  },
                  category: {
                    type: :string,
                    description: <<~DESC.strip,
                      Whatever category the user wants to use. Example: food,
                      groceries, rent, Meggie's Bday Party, etc. When unclear,
                      do not hesitate to make it null. The language of the input
                      must be preserved.
                      It's crucial that you get this right,
                      otherwise I might lose my job. Please be careful.
                    DESC
                  },
                },
                required: ['amount_cents'],
              },
            }
          end
        end
      end
    end
  end
end

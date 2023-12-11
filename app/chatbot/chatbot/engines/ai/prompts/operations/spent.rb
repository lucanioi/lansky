module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          class Spent
            PROMPTS = {
              name: 'spent',
              description: '[Spent] Registers the user\'s spending with categories',
              parameters: {
                type: :object,
                properties: {
                  amount_cents: {
                    type: :integer,
                    description: <<~DESC.strip,
                      The amount of money spent.
                      #{Shared::CENTS}
                      #{Shared::VERY_IMPORTANT_MESSAGE}
                    DESC
                  },
                  category: {
                    type: :string,
                    description: <<~DESC.strip,
                      Whatever category the user wants to use. Example: food,
                      groceries, rent, Meggie's Bday Party, etc. When unclear,
                      do not hesitate to make it null. The language of the input
                      must be preserved.
                      #{Shared::VERY_IMPORTANT_MESSAGE}
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

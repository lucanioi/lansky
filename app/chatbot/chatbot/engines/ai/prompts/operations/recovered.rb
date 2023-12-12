module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          class Recovered
            PROMPTS = {
              name: 'recovered',
              description: <<~DESC.strip,
                [Recovered] Registers the amount of money user has recovered.
                A recovery could be a reimbursement, a refund, a gift, etc.
              DESC
              parameters: {
                type: :object,
                properties: {
                  amount_cents: {
                    type: :integer,
                    description: <<~DESC.strip,
                      The amount of money recovered.
                      #{Shared::CENTS}
                      #{Shared::VERY_IMPORTANT_MESSAGE}
                    DESC
                  },
                  category_name: {
                    type: :string,
                    description: <<~DESC.strip,
                      Whatever category the user wants to use. Example: food,
                      groceries, rent, Meggie's Bday Party, etc. When unclear,
                      do not hesitate to make it null. The language of the input
                      must be preserved. Use the exact same words as the user.
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

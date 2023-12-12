module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          module GetTimezone
            PROMPT = {
              name: 'get_timezone',
              description: <<~DESC.strip,
                [Get Timezone] Returns the user's timezone.
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

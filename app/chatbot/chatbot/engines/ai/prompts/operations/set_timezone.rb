module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          class SetTimezone
            SUPPORTED_TIMEZONES = %w[
              America/Los_Angeles
              America/Denver
              America/Chicago
              America/New_York
              Pacific/Honolulu
              America/Juneau
              America/Phoenix
              UTC
              Europe/London
              Europe/Berlin
              Europe/Paris
              Europe/Moscow
              Europe/Madrid
              Europe/Rome
              Europe/Amsterdam
              Europe/Vilnius
              Asia/Shanghai
              Asia/Tokyo
              Asia/Seoul
              Asia/Jakarta
              Asia/Bangkok
              Asia/Kolkata
              Asia/Singapore
              Australia/Sydney
              Pacific/Auckland
              America/Sao_Paulo
            ].freeze

            PROMPTS = {
              name: 'set_timezone',
              description: <<~DESC.strip,
                [Set Timezone] Sets the user's timezone
              DESC
              parameters: {
                type: :object,
                properties: {
                  timezone_name: {
                    type: :string,
                    description: <<~DESC.strip,
                      A timezone in valid string format.
                      #{Shared::ONLY_ACCEPTED_VALUES}
                      #{Shared::VERY_IMPORTANT_MESSAGE}
                    DESC
                    enum: SUPPORTED_TIMEZONES,
                  },
                },
                required: ['timezone_name'],
              },
            }
          end
        end
      end
    end
  end
end

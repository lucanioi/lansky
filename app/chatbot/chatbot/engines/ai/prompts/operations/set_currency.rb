module Chatbot
  module Engines
    module AI
      module Prompts
        module Operations
          class SetCurrency
            SUPPORTED_CURRENCIES = [
              "USD",  # United States Dollar
              "EUR",  # Euro
              "JPY",  # Japanese Yen
              "GBP",  # British Pound Sterling
              "AUD",  # Australian Dollar
              "CAD",  # Canadian Dollar
              "CHF",  # Swiss Franc
              "CNY",  # Chinese Yuan
              "SEK",  # Swedish Krona
              "NZD",  # New Zealand Dollar
              "MXN",  # Mexican Peso
              "SGD",  # Singapore Dollar
              "HKD",  # Hong Kong Dollar
              "NOK",  # Norwegian Krone
              "KRW",  # South Korean Won
              "TRY",  # Turkish Lira
              "RUB",  # Russian Ruble
              "INR",  # Indian Rupee
              "BRL",  # Brazilian Real
              "ZAR",  # South African Rand
              "THB",  # Thai Baht
              "IDR",  # Indonesian Rupiah
              "MYR",  # Malaysian Ringgit
              "PHP",  # Philippine Peso
              "PLN",  # Polish Zloty
              "AED",  # United Arab Emirates Dirham
              "SAR",  # Saudi Riyal
              "ILS",  # Israeli New Shekel
              "DKK",  # Danish Krone
              "TWD"   # Taiwan Dollar
            ].freeze

            PROMPTS = {
              name: 'set_currency',
              description: <<~DESC.strip,
                [Set Currency] Sets the user's currency
              DESC
              parameters: {
                type: :object,
                properties: {
                  currency: {
                    type: :string,
                    description: <<~DESC.strip,
                      A currency in valid 3-letter ISO format.
                      #{Shared::ONLY_ACCEPTED_VALUES}
                      #{Shared::VERY_IMPORTANT_MESSAGE}
                    DESC
                    enum: SUPPORTED_CURRENCIES,
                  },
                },
                required: ['currency'],
              },
            }
          end
        end
      end
    end
  end
end

require_relative 'errors'

module Chatbot
  module Engines
    module Classic
      module Parsers
        class SetBudget < Base
          def to_h
            { period:, amount_cents: }
          end

          private

          def period
            string = argument.split(' ')[0..-2].join(' ')
            date_params = DateExtractor.run(string:).value!
            Chatbot::Parsers::Date::Parser.parse_from_params(**date_params, direction: :forward)
          end

          def amount_cents
            amount = argument.split(' ')[-1]
            amount = Helpers::MoneyHelper.parse_amount(amount)

            amount || raise(Parsers::InvalidAmount, "Invalid amount: #{argument}")
          end

          def argument
            message.delete_prefix('set budget').strip.downcase
          end
        end
      end
    end
  end
end

require_relative 'errors'

module Chatbot
  module Engines
    module Classic
      module Parsers
        class SetBudget < Base
          def to_h
            { flex_date:, amount_cents: }
          end

          private

          def flex_date
            string = argument.split(' ')[0..-2].join(' ')
            date_params = DateExtractor.run(string:).value!

            Lansky::FlexibleDate.new(**date_params)
          end

          def amount_cents
            amount = argument.split(' ')[-1]
            amount = Helpers::MoneyHelper.parse_amount(amount)

            amount || raise(Parsers::Errors::InvalidAmount, "Invalid amount: #{argument}")
          end

          def argument
            message.delete_prefix('set budget').strip.downcase
          end
        end
      end
    end
  end
end

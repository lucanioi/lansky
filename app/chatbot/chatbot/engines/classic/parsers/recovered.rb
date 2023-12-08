require_relative 'errors'

module Chatbot
  module Engines
    module Classic
      module Parsers
        class Recovered < Base
          def to_h
            { category_name:, amount_cents: }
          end

          private

          def category_name
            argument.split(' ')[1..-1].join(' ').presence
          end

          def amount_cents
            amount = argument.split(' ')[0]
            amount = Helpers::MoneyHelper.parse_amount(amount)

            amount || raise(Parsers::InvalidAmount, "Invalid amount: #{argument}")
          end

          def argument
            message.delete_prefix('recovered ').strip
          end
        end
      end
    end
  end
end

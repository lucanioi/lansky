module Chatbot
  module Engines
    module Classic
      module Parsers
        class SetCurrency < Base
          def to_h
            { currency: }
          end

          private

          def currency
            argument.strip.downcase
          end

          def argument
            message.delete_prefix('set currency')
          end
        end
      end
    end
  end
end

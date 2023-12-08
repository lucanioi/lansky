module Chatbot
  module Engines
    module Classic
      module Parsers
        class Spending < Base
          def to_h
            { period: }
          end

          private

          def period
            argument.downcase
          end

          def argument
            message.delete_prefix('spending').strip
          end
        end
      end
    end
  end
end

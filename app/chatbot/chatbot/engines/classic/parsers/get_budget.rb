module Chatbot
  module Engines
    module Classic
      module Parsers
        class GetBudget < Base
          def to_h
            { period: extract_period }
          end

          private

          def extract_period
            argument.downcase
          end

          def argument
            message.delete_prefix('get').strip.delete_prefix('budget').strip
          end
        end
      end
    end
  end
end
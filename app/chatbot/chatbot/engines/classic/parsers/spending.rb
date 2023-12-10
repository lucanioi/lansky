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
            date_params = DateExtractor.run(string: argument).value!
            Chatbot::Parsers::Date::Parser.parse_from_params(**date_params, direction: :backward)
          end

          def argument
            message.delete_prefix('spending').strip.downcase
          end
        end
      end
    end
  end
end

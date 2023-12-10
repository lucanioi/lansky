module Chatbot
  module Engines
    module Classic
      module Parsers
        class GetBudget < Base
          def to_h
            { period: }
          end

          private

          def period
            return nil if argument.blank?

            date_params = DateExtractor.run(string: argument).value!
            Chatbot::Parsers::Date::Parser.parse_from_params(**date_params)
          end

          def argument
            message.delete_prefix('get').strip.delete_prefix('budget').strip
          end
        end
      end
    end
  end
end

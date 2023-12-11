module Chatbot
  module Engines
    module Classic
      module Parsers
        class Spending < Base
          def to_h
            { flex_date: }
          end

          private

          def flex_date
            date_params = DateExtractor.run(string: argument).value!

            Lansky::FlexibleDate.new(**date_params)
          end

          def argument
            message.delete_prefix('spending').strip.downcase
          end
        end
      end
    end
  end
end

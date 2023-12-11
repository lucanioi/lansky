module Chatbot
  module Engines
    module Classic
      module Parsers
        class GetBudget < Base
          def to_h
            { flex_date: }
          end

          private

          def flex_date
            return nil if argument.blank?

            date_params = DateExtractor.run(string: argument).value!

            Lansky::FlexibleDate.new(**date_params)
          end

          def argument
            message.delete_prefix('get').strip.delete_prefix('budget').strip
          end
        end
      end
    end
  end
end

module Chatbot
  module Parsers
    module Date
      class Year < DateComponent
        NUMERIC_YEARS = ('2000'..'2100').to_a

        def resolve(datetime)
          return datetime.change(year: number) if numeric?

          datetime
        end

        private

        def number
          string.to_i if numeric?
        end

        def numeric?
          NUMERIC_YEARS.include?(string)
        end
      end
    end
  end
end

module Chatbot
  module Parsers
    module Date
      class Week < DateComponent
        NUMERIC_WEEKS = ('1'..'5').to_a

        def resolve(datetime)
          return datetime if blank?

          month_start = datetime.change(day: 1)
          first_week = first_week_start(month_start)
          nth_week_start = first_week + (number - 1).weeks

          datetime.change(month: nth_week_start.month, day: nth_week_start.day)
        end

        private

        def first_week_start(datetime)
          wday = (datetime.wday - 1) % 7 # consider monday to be 0; default is 1

          if wday < 4
            datetime - wday.days
          else
            (datetime - wday.days) + 7.days
          end
        end

        def number
          string.to_i if numeric?
        end

        def numeric?
          NUMERIC_WEEKS.include?(string)
        end
      end
    end
  end
end

module Chatbot
  module Parsers
    module Date
      class Day < DateComponent
        DAYS_OF_WEEK      = %w[sunday monday tuesday wednesday thursday
                            friday saturday]
        DAYS_OF_WEEK_ABBR = %w[sun mon tue wed thu fri sat]
        NUMERIC_DAYS   = ('1'..'31').to_a

        def resolve(datetime)
          return datetime.change(day: 1) if blank?
          return datetime.change(day: number) if numeric?
          resolve_named(datetime)
        end

        private

        def resolve_named(datetime)
          current_day = datetime.wday
          difference  = (number - current_day) % 7

          case direction
          when :forward
            difference = 7 if difference.zero? && !include_current
          when :backward
            difference -= 7 unless difference.zero? && include_current
          end

          datetime + difference.days
        end

        def number
          return string.to_i if numeric?

          (DAYS_OF_WEEK.index(string) || DAYS_OF_WEEK_ABBR.index(string))
        end

        def numeric?
          NUMERIC_DAYS.include?(string)
        end
      end
    end
  end
end

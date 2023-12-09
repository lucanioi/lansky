module Chatbot
  module Parsers
    module Date
      class Day < DateComponent
        DAYS_OF_WEEK      = %w[sunday monday tuesday wednesday thursday
                            friday saturday]
        DAYS_OF_WEEK_ABBR = %w[sun mon tue wed thu fri sat]
        NUMERIC_DAYS   = ('1'..'31').to_a

        def resolve(datetime)
          return datetime if blank? && parent_present
          return datetime.change(day: 1) if blank?
          return datetime.change(day: number) if numeric?

          resolve_named(datetime)
        end

        private

        def resolve_named(datetime)
          return datetime unless named?

          difference = wday - datetime.wday
          datetime + adjust_difference(difference).days
        end

        def adjust_difference(diff)
          return diff if direction == :current
          diff %= 7
          return diff if diff.zero? && include_current
          return diff - 7 if direction == :backward
          diff.zero? ? 7 : diff
        end

        def number
          string.to_i if numeric?
        end

        def wday
          return unless named?

          n = (DAYS_OF_WEEK.index(string) || DAYS_OF_WEEK_ABBR.index(string))

          n.zero? ? 7 : n
        end

        def numeric?
          NUMERIC_DAYS.include?(string)
        end

        def named?
          DAYS_OF_WEEK.include?(string) || DAYS_OF_WEEK_ABBR.include?(string)
        end
      end
    end
  end
end

module Chatbot
  module Parsers
    module Date
      class Day < DateComponent
        InvalidDay = Class.new(StandardError)

        DAYS_OF_WEEK      = %w[sunday monday tuesday wednesday thursday
                            friday saturday]
        DAYS_OF_WEEK_ABBR = %w[sun mon tue wed thu fri sat]
        NUMERIC_DAYS   = ('1'..'31').to_a

        DEICTIC_OPTIONS = %w[today tomorrow yesterday].freeze

        def resolve(datetime)
          return datetime if blank? && parent_present
          return resolve_deictic(datetime) if deictic?
          return datetime.change(day: 1) if blank?
          return datetime.change(day: number) if valid_numeric?

          resolve_named(datetime)
        end

        def valid_numeric?
          NUMERIC_DAYS.include?(string)
        end

        def named?
          DAYS_OF_WEEK.include?(string) || DAYS_OF_WEEK_ABBR.include?(string)
        end

        def deictic?
          DEICTIC_OPTIONS.include?(string)
        end

        private

        def resolve_deictic(datetime)
          offset = case string
                   when 'today'     then 0
                   when 'tomorrow'  then 1
                   when 'yesterday' then -1
                   end

          datetime + offset.days
        end

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
          string.to_i if valid_numeric?
        end

        def wday
          return unless named?

          n = (DAYS_OF_WEEK.index(string) || DAYS_OF_WEEK_ABBR.index(string))

          n.zero? ? 7 : n
        end

        def validate!
          return if valid_numeric? || named? || deictic? || blank?

          raise InvalidDay, "Invalid day: #{string}"
        end
      end
    end
  end
end

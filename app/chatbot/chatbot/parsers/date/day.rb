module Chatbot
  module Parsers
    module Date
      class Day < DateComponent
        InvalidDay = Class.new(StandardError)

        DAYS_OF_WEEK      = %w[sunday monday tuesday wednesday thursday
                            friday saturday]
        DAYS_OF_WEEK_ABBR = %w[sun mon tue wed thu fri sat]

        VALID_NUMERIC   = (1..31)
        DEICTIC_OPTIONS = %w[today tomorrow yesterday].freeze

        def resolve(datetime)
          return datetime if blank? && parent_present
          return datetime.change(day: 1) if blank?
          return resolve_deictic(datetime) if deictic?
          return datetime.change(day: number) if valid_numeric?
          return resolve_named(datetime) if named?

          datetime
        end

        def valid_numeric?
          VALID_NUMERIC.cover?(string.to_i)
        end

        def named?
          !!string&.match?(names_regex)
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

          n = (DAYS_OF_WEEK_ABBR.index(normalized_name))

          n.zero? ? 7 : n
        end

        def names
          DAYS_OF_WEEK + DAYS_OF_WEEK_ABBR
        end

        def normalized_name
          name = names.find { |name| string.end_with?(name) }
          return unless name

          name[0..2]
        end

        def names_regex
          @names_regex ||= Regexp.new(names.join('|'))
        end

        def validate!
          return if valid_numeric? || named? || deictic? || blank?

          raise InvalidDay, "Invalid day: #{string}"
        end
      end
    end
  end
end

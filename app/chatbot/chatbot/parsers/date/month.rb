module Chatbot
  module Parsers
    module Date
      class Month < DateComponent
        InvalidMonth = Class.new(StandardError)

        MONTHS_OF_YEAR      = %w[january february march april may june july august
                                september october november december]
        MONTHS_OF_YEAR_ABBR = %w[jan feb mar apr may jun jul aug sep oct nov dec]

        VALID_NUMERIC = (1..12)

        def resolve(datetime)
          return datetime.change(month: 1) if blank? && parent_present
          return datetime.change(month: number) if valid_numeric?
          return resolve_deictic(datetime) if deictic?
          return resolve_named(datetime) unless blank?

          datetime
        end

        def valid_numeric?
          VALID_NUMERIC.cover?(string.to_i)
        end

        def named?
          !!string&.match?(names_regex)
        end

        private

        def resolve_deictic(datetime)
          case string
          when 'this' then datetime
          when 'next' then datetime.next_month
          when 'prev' then datetime.prev_month
          end
        end

        def resolve_named(datetime)
          difference = number - datetime.month

          datetime + adjust_difference(difference).months
        end

        def adjust_difference(diff)
          return diff if direction == :current
          diff %= 12
          return diff if diff.zero? && include_current
          return diff - 12 if direction == :backward
          diff.zero? ? 12 : diff
        end

        def number
          return string.to_i if valid_numeric?

          index = MONTHS_OF_YEAR_ABBR.index(normalized_name)

          index && index + 1
        end

        def names_regex
          @names_regex ||= Regexp.new(names.join('|'))
        end

        def names
          MONTHS_OF_YEAR + MONTHS_OF_YEAR_ABBR
        end

        def normalized_name
          name = names.find { |name| string.end_with?(name) }
          return unless name

          name[0..2]
        end

        def validate!
          return if valid_numeric? || named? || deictic? || blank?

          raise InvalidMonth, "Invalid month: #{string}"
        end
      end
    end
  end
end

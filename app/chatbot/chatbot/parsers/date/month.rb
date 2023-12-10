module Chatbot
  module Parsers
    module Date
      class Month < DateComponent
        InvalidMonth = Class.new(StandardError)

        MONTHS_OF_YEAR = %w[jan feb mar apr may jun jul aug sep oct nov dec]

        def resolve(datetime)
          return datetime.change(month: 1) if blank? && parent_present
          return resolve_deictic(datetime) if deictic?
          return resolve_named(datetime) unless blank?

          datetime
        end

        def valid_numeric?
          false
        end

        def named?
          !!string&.match?(names_regex)
        end

        private

        def resolve_deictic(datetime)
          case string.delete_suffix('month').strip
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

          index = MONTHS_OF_YEAR.index(normalized_name)

          index && index + 1
        end

        def names_regex
          @names_regex ||= Regexp.new(MONTHS_OF_YEAR.join('|'))
        end

        def normalized_name
          name = string.gsub(/next|prev|this/, '').strip

          return name if MONTHS_OF_YEAR.include?(name)
        end

        def validate!
          return if valid_numeric? || named? || deictic? || blank?

          raise InvalidMonth, "Invalid month: #{string}"
        end
      end
    end
  end
end

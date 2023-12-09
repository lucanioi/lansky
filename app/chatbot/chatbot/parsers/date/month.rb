module Chatbot
  module Parsers
    module Date
      class Month < DateComponent
        InvalidMonth = Class.new(StandardError)

        MONTHS_OF_YEAR      = %w[january february march april may june july august
                                september october november december]
        MONTHS_OF_YEAR_ABBR = %w[jan feb mar apr may jun jul aug sep oct nov dec]
        NUMERIC_MONTHS = ('1'..'12').to_a

        def resolve(datetime)
          return datetime.change(month: 1) if blank? && parent_present
          return datetime.change(month: number) if valid_numeric?
          return resolve_deictic(datetime) if deictic?
          return resolve_named(datetime) unless blank?

          datetime
        end

        def valid_numeric?
          NUMERIC_MONTHS.include?(string)
        end

        def named?
          MONTHS_OF_YEAR.include?(string) ||
            MONTHS_OF_YEAR_ABBR.include?(string)
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

          index = (MONTHS_OF_YEAR.index(string) ||
                    MONTHS_OF_YEAR_ABBR.index(string))

          index && index + 1
        end

        def validate!
          return if valid_numeric? || named? || deictic? || blank?

          raise InvalidMonth, "Invalid month: #{string}"
        end
      end
    end
  end
end

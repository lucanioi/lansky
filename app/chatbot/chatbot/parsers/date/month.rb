module Chatbot
  module Parsers
    module Date
      class Month < DateComponent
        MONTHS_OF_YEAR      = %w[january february march april may june july august
                                september october november december]
        MONTHS_OF_YEAR_ABBR = %w[jan feb mar apr may jun jul aug sep oct nov dec]
        NUMERIC_MONTHS = ('1'..'12').to_a

        def resolve(datetime)
          return datetime.change(month: number) if numeric?
          return resolve_named(datetime) unless blank?

          datetime
        end

        private

        def resolve_named(datetime)
          difference = (number - datetime.month) % 12

          case direction
          when :forward
            difference = 12 if difference.zero? && !include_current
          when :backward
            difference -= 12 unless difference.zero? && include_current
          end

          datetime + difference.months
        end

        def number
          return string.to_i if numeric?

          index = (MONTHS_OF_YEAR.index(string) ||
                    MONTHS_OF_YEAR_ABBR.index(string))

          index && index + 1
        end

        def numeric?
          NUMERIC_MONTHS.include?(string)
        end
      end
    end
  end
end

module Chatbot
  module Parsers
    module Date
      class Year < DateComponent
        InvalidYear = Class.new(StandardError)

        VALID_NUMERIC = (1900..2100)

        def resolve(datetime)
          return datetime.change(year: number) if valid_numeric?
          return resolve_deictic(datetime) if deictic?

          datetime
        end

        def named?
          false
        end

        def valid_numeric?
          VALID_NUMERIC.cover?(string.to_i)
        end

        private

        def resolve_deictic(datetime)
          case string.delete_suffix('year').strip
          when 'this' then datetime
          when 'next' then datetime.next_year
          when 'prev' then datetime.prev_year
          end
        end

        def number
          string.to_i if valid_numeric?
        end

        def validate!
          return if valid_numeric? || deictic? || blank?

          raise InvalidYear, "Invalid year: #{string}"
        end
      end
    end
  end
end

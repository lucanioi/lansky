module Lansky
  class FlexibleDate
    class Week < DateComponent
      InvalidWeek = Class.new(StandardError)

      VALID_NUMERIC = (1..5)

      def resolve(datetime)
        return datetime if blank?
        return resolve_numeric(datetime) if valid_numeric?

        resolve_deictic(datetime)
      end

      def valid_numeric?
        VALID_NUMERIC.cover?(string.to_i)
      end

      private

      def resolve_numeric(datetime)
        month_start = datetime.change(day: 1)
        first_week = first_week_start(month_start)
        nth_week_start = first_week + (number - 1).weeks

        datetime.change(month: nth_week_start.month, day: nth_week_start.day)
      end

      def resolve_deictic(datetime)
        offset = case string.delete_suffix('week').strip
                  when 'this' then 0
                  when 'next' then 7
                  when 'prev' then -7
                  end

        datetime.bow + offset.days
      end

      def first_week_start(datetime)
        wday = (datetime.wday - 1) % 7 # consider monday to be 0; default is 1

        if wday < 4
          datetime - wday.days
        else
          (datetime - wday.days) + 7.days
        end
      end

      def number
        string.to_i if valid_numeric?
      end

      def validate!
        return if valid_numeric? || deictic? || blank?

        raise InvalidWeek, "Invalid week: #{string}"
      end
    end
  end
end

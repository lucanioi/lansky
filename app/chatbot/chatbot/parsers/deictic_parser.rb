module Chatbot
  module Parsers
    class DeicticParser
      InvalidPeriod = Class.new(Lansky::DisplayableError)

      DAYS_OF_WEEK      = %w[sunday monday tuesday wednesday thursday
                             friday saturday]
      DAYS_OF_WEEK_ABBR = %w[sun mon tue wed thu fri sat]

      MONTHS_OF_YEAR      = %w[january february march april may june july august
                               september october november december]
      MONTHS_OF_YEAR_ABBR = %w[jan feb mar apr may jun jul aug sep oct nov dec]

      DEICTIC_TO_DAY = {
        'yesterday'  => ->(*) { DateTime.current.yesterday},
        'today'      => ->(*) { DateTime.current},
        'tomorrow'   => ->(*) { DateTime.current.tomorrow },

        'last week'  => ->(*) { DateTime.current.prev_week},
        'this week'  => ->(*) { DateTime.current.bow},
        'next week'  => ->(*) { DateTime.current.next_week},

        'last month' => ->(*) { DateTime.current.prev_month.bom},
        'this month' => ->(*) { DateTime.current.bom},
        'next month' => ->(*) { DateTime.current.next_month.bom},

        'last year'  => ->(*) { DateTime.current.prev_year.boy},
        'this year'  => ->(*) { DateTime.current.boy},
        'next year'  => ->(*) { DateTime.current.next_year.boy},
      }

      class << self
        def parse_period(day: nil, week: nil, month: nil, year: nil, **params)
          new(day:, week:, month:, year:, **params).parse_period
        end

        private :new
      end

      def initialize(day:, week:, month:, year:, **params)
        @day = day
        @week = week
        @month = month
        @year = year

        @include_current = params[:include_current]
        @direction = params[:direction]
      end

      def parse_period
        Models::Period.new(period_start:, period_end:)
      end

      def period_start
        return deitic_combo if present_attrs.size == 2
        return deitic_solo if present_attrs.size == 1

        raise InvalidPeriod, "Invalid period: #{day} #{week} #{month} #{year}"
      end

      def period_end
        case
        when day.present? then period_start + 1.day
        when week.present? then period_start + 1.week
        when month.present? then period_start + 1.month
        else
          period_start + 1.year
        end
      end

      private

      attr_reader :day, :week, :month, :year, :include_current, :direction

      # One deitic combined with one non-deitic. like 'last week' and 'monday'
      # or 'this month' and '15'
      def deitic_combo
        case
        when day.present? && week.present? then day_week_combo
        when day.present? && month.present? then day_month_combo
        when week.present? && month.present? then week_month_combo
        when month.present? && year.present? then month_year_combo
        else
          raise invalid_period!('invalid deitic combo')
        end
      end

      def deitic_solo
        return DEICTIC_TO_DAY[*present_attrs].call if DEICTIC_TO_DAY.key?(*present_attrs)
        return parse_day if day.present?
        return parse_month if month.present?

        raise invalid_period!('invalid deitic period')
      end

      def present_attrs
        [day, week, month, year].compact
      end

      # e.g. "last week tuesday"
      def day_week_combo
        invalid_period!("day must be 'mon', 'Tuesday', " \
                        'etc in a day-week deitic combo') unless wday?
        invalid_period!("week must be 'this week', 'last week', " \
                        "or 'next week' in a day-week deitic combo") unless deictic_week?

        week_start = DEICTIC_TO_DAY[week].call # always monday, thus 1
        difference = (wday_to_num(day) - 1) % 7

        week_start + difference.days
      end

      # e.g. "last month 15" or "next month 1"
      def day_month_combo
        invalid_period!("day must be '1', '15', etc in a day-month deitic combo") unless day.to_i.in?(1..31)
        invalid_period!("month must be 'this month', 'last august', " \
                        "'next month' etc in a day-month deitic combo") unless deictic_month?

        month_start = DEICTIC_TO_DAY[month].call
        month_start + (day.to_i - 1).days
      end

      # e.g. "week 3 last month" or "week 1 next month"
      def week_month_combo
        invalid_period!("week must be '1', '2', '3', or '4' in a week-month deitic combo") unless week.to_i.in?(1..4)
        invalid_period!("month must be 'this month', 'last august', " \
                        "'next month', etc in a week-month deitic combo") unless deictic_month?

        month_start = parse_month
        difference = (month_start.wday - 1) % 7
        first_week = if difference < 4
                       month_start - difference.days
                     else
                       month_start + (7 - difference).days
                     end

        first_week + (week.to_i - 1).weeks
      end

      # e.g. "august last year" or "august next year"
      def month_year_combo
        invalid_period!("month must be 'january', 'august', etc in a month-year deitic combo") unless month.in?(MONTHS_OF_YEAR)
        invalid_period!("year must be 'this year', 'last year', " \
                        "'next year', etc in a month-year deitic combo") unless year.match?(/last |next |this /)

        year_start = parse_year
        month_num = month_name_to_num(extract_period_name(month))

        year_start.change(month: month_num).bom
      end

      def parse_day
        return DEICTIC_TO_DAY[day].call if DEICTIC_TO_DAY.key?(day)

        day_num = wday_to_num(extract_period_name(day))

        case day
        when /last /
          DateTime.current - (DateTime.current.wday - day_num) % 7
        when /next |this /
          DateTime.current + (day_num - DateTime.current.wday) % 7
        else
          raise invalid_period!('invalid deictic day')
        end
      end

      def parse_month
        return DEICTIC_TO_DAY[month].call if DEICTIC_TO_DAY.key?(month)

        month_num = month_name_to_num(extract_period_name(month))

        case month
        when /last /
          DateTime.current.month < month_num ?
            DateTime.current.prev_year.change(month: month_num).bom :
            DateTime.current.change(month: month_num).bom
        when /next /
          DateTime.current.month > month_num ?
            DateTime.current.next_year.change(month: month_num).bom :
            DateTime.current.change(month: month_num).bom
        when /this /
          DateTime.current.change(month: month_num).bom
        else
          raise invalid_period!('invalid deictic month')
        end
      end

      def parse_year
        DEICTIC_TO_DAY[year].call if DEICTIC_TO_DAY.key?(year)
      end

      def extract_period_name(str)
        str.sub(/last |next |this /, '')
      end

      def wday?
        DAYS_OF_WEEK.include?(day) || DAYS_OF_WEEK_ABBR.include?(day)
      end

      def deictic_week?
        ['this week', 'last week', 'next week'].include?(week)
      end

      def deictic_month?
        month.match?(/last |next |this /)
      end

      def month_name_to_num(month_name)
        (MONTHS_OF_YEAR.index(month_name) ||
         MONTHS_OF_YEAR_ABBR.index(month_name)) + 1
      end

      def wday_to_num(wday)
        (DAYS_OF_WEEK.index(wday) || DAYS_OF_WEEK_ABBR.index(wday))
      end

      def skip_validations?
        @skip_validations
      end

      def invalid_period!(msg)
        raise InvalidPeriod, "Invalid period: #{msg}\n\n" \
                             "day: #{day.inspect}\n" \
                             "week: #{week.inspect}\n" \
                             "month: #{month.inspect}\n" \
                             "year: #{year.inspect}"
      end
    end
  end
end

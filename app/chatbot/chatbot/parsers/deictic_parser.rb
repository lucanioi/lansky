# frozen_string_literal: true

module Chatbot
  module Parsers
    class DeicticParser
      InvalidPeriod = Class.new(Lansky::DisplayableError)

      DAYS_OF_WEEK      = %w[sunday monday tuesday wednesday thursday
                             friday saturday].freeze
      DAYS_OF_WEEK_ABBR = %w[sun mon tue wed thu fri sat].freeze

      MONTHS_OF_YEAR      = %w[january february march april may june july august
                               september october november december].freeze
      MONTHS_OF_YEAR_ABBR = %w[jan feb mar apr may jun jul aug sep oct nov dec].freeze

      DEICTIC_TO_DAY = {
        'yesterday' => ->(*) { DateTime.current.yesterday},
        'today'     => ->(*) { DateTime.current},
        'tomorrow'  => ->(*) { DateTime.current.tomorrow },
      }.freeze

      DEICTIC_TO_WEEK = {
        'last' => ->(*) { DateTime.current.prev_week},
        'this' => ->(*) { DateTime.current.bow},
        'next' => ->(*) { DateTime.current.next_week},
      }.freeze

      DEICTIC_TO_MONTH = {
        'last' => ->(*) { DateTime.current.prev_month.bom},
        'this' => ->(*) { DateTime.current.bom},
        'next' => ->(*) { DateTime.current.next_month.bom},
      }.freeze

      DEICTIC_TO_YEAR = {
        'last' => ->(*) { DateTime.current.prev_year.boy},
        'this' => ->(*) { DateTime.current.boy},
        'next' => ->(*) { DateTime.current.next_year.boy},
      }.freeze

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

        @include_current = params[:include_current] || false
        @direction = params[:direction] || :forward
      end

      def parse_period
        Models::Period.new(period_start:, period_end:)
      end

      def period_start
        return deictic_combo if present_attrs.size == 2
        return deictic_solo if present_attrs.size == 1

        raise invalid_period!('invalid deictic period')
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

      # One deictic combined with one non-deictic. like 'last week' and 'monday'
      # or 'this month' and '15'
      def deictic_combo
        case
        when day.present? && week.present? then day_week_combo
        when day.present? && month.present? then day_month_combo
        when week.present? && month.present? then week_month_combo
        when month.present? && year.present? then month_year_combo
        else
          raise invalid_period!('invalid deictic combo')
        end
      end

      def deictic_solo
        return parse_day if day.present?
        return parse_week if week.present?
        return parse_month if month.present?
        return parse_year if year.present?

        raise invalid_period!('invalid deictic period')
      end

      # e.g. "last week tuesday"
      def day_week_combo
        invalid_period! unless wday?
        invalid_period! unless deictic?(week)

        week_start = DEICTIC_TO_WEEK[week].call # always monday, thus 1
        difference = (wday_to_num(day) - 1) % 7

        week_start + difference.days
      end

      # e.g. "last month 15" or "next month 1"
      def day_month_combo
        invalid_period! unless day.to_i.in?(1..31)
        invalid_period! unless deictic?(month)

        month_start = DEICTIC_TO_MONTH[month].call
        month_start + (day.to_i - 1).days
      end

      # e.g. "week 3 last month" or "week 1 next month"
      def week_month_combo
        invalid_period! unless week.to_i.in?(1..4)

        invalid_period! unless deictic?(month)

        month_start = parse_month
        difference = (month_start.wday - 1) % 7
        first_week = difference < 4 ?
                      month_start - difference.days :
                      month_start + (7 - difference).days

        first_week + (week.to_i - 1).weeks
      end

      # e.g. "august last year" or "august next year"
      def month_year_combo
        invalid_period! unless month.in?(MONTHS_OF_YEAR)
        invalid_period! unless deictic?(year)

        year_start = parse_year
        month_num = month_name_to_num(extract_period_name(month))

        year_start.change(month: month_num).bom
      end

      def parse_day
        return DEICTIC_TO_DAY[day].call if DEICTIC_TO_DAY.key?(day)

        day_num = wday_to_num(extract_period_name(day))

        case day
        when /last/
          DateTime.current - (DateTime.current.wday - day_num) % 7
        when /next|this/
          DateTime.current + (day_num - DateTime.current.wday) % 7
        else
          raise invalid_period!('invalid deictic day')
        end
      end

      def parse_week
        DEICTIC_TO_WEEK[week].call if DEICTIC_TO_WEEK.key?(week)
      end

      def parse_month
        return DEICTIC_TO_MONTH[month].call if DEICTIC_TO_MONTH.key?(month)

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
        DEICTIC_TO_YEAR[year].call if DEICTIC_TO_YEAR.key?(year)
      end

      def extract_period_name(str)
        str.sub(/last |next |this /, '')
      end

      def wday?
        DAYS_OF_WEEK.include?(day) || DAYS_OF_WEEK_ABBR.include?(day)
      end

      def deictic?(str)
        str.match?(/last|next|this/)
      end

      def month_name_to_num(month_name)
        (MONTHS_OF_YEAR.index(month_name) ||
         MONTHS_OF_YEAR_ABBR.index(month_name)) + 1
      end

      def wday_to_num(wday)
        (DAYS_OF_WEEK.index(wday) || DAYS_OF_WEEK_ABBR.index(wday))
      end

      def present_attrs
        [day, week, month, year].compact
      end

      def skip_validations?
        @skip_validations
      end

      def invalid_period!(msg = '')
        raise InvalidPeriod, "Invalid period: #{msg}\n\n" \
                             "day: #{day.inspect}\n" \
                             "week: #{week.inspect}\n" \
                             "month: #{month.inspect}\n" \
                             "year: #{year.inspect}"
      end
    end
  end
end

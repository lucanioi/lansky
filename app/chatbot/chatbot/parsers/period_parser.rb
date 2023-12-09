module Chatbot
  module Parsers
    class PeriodParser
      InvalidPeriod = Class.new(Lansky::DisplayableError)

      DAYS_OF_WEEK      = %w[monday tuesday wednesday thursday
                             friday saturday sunday]
      DAYS_OF_WEEK_ABBR = %w[mon tue wed thu fri sat sun]

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

      VALID_DAY_VALUES = [
        DAYS_OF_WEEK,
        MONTHS_OF_YEAR_ABBR,
        ('1'..'31').to_a,
        ['today', 'yesterday', 'tomorrow'],
        ['this ', 'last ', 'next '].product(DAYS_OF_WEEK).map(&:join)
      ].flatten.freeze

      VALID_WEEK_VALUES = [
        ['this week', 'last week', 'next week'],
        ('1'..'4').to_a,
      ].flatten.freeze

      VALID_MONTH_VALUES = [
        MONTHS_OF_YEAR,
        MONTHS_OF_YEAR_ABBR,
        ('1'..'12').to_a,
        ['this month', 'last month', 'next month'],
        ['this ', 'last ', 'next '].product(MONTHS_OF_YEAR).map(&:join)
      ].flatten.freeze

      VALID_YEAR_VALUES = [
        ('1900'..'2100').to_a,
        ['this year', 'last year', 'next year'],
      ].flatten.freeze

      VALID_VALUES = [
        VALID_DAY_VALUES,
        VALID_WEEK_VALUES,
        VALID_MONTH_VALUES,
        VALID_YEAR_VALUES,
      ].flatten.freeze

      class << self
        def parse_period_single(input, **options)
          day, week, month, year = nil
          input = input.downcase.strip

          case
          when VALID_DAY_VALUES.include?(input) then day = input
          when VALID_WEEK_VALUES.include?(input) then week = input
          when VALID_MONTH_VALUES.include?(input) then month = input
          when VALID_YEAR_VALUES.include?(input) then year = input
          else
            raise ArgumentError, "Invalid period: #{input}"
          end

          parse_period(day:, week:, month:, year:, skip_validations: true, **options)
        end

        def parse_period(day: nil, week: nil, month: nil, year: nil, **options)
          new(day:, week:, month:, year:, **options).parse_period
        end

        private :new
      end

      def initialize(**params)
        @day   = params[:day]
        @week  = params[:week]
        @month = params[:month]
        @year  = params[:year]

        @include_current  = params[:include_current] || false
        @direction        = params[:direction] || :forward
        @skip_validations = params[:skip_validations] || false
      end

      def parse_period
        Models::Period.new(period_start:, period_end:)
      end

      private

      attr_reader :day, :week, :month, :year, :include_current, :direction

      def period_start
        DateTime.new(parse_year, parse_month, parse_day)
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

      def parse_year
        return DateTime.current.year if year.nil?

        validate!(year, VALID_YEAR_VALUES, 'year')
        return DEICTIC_TO_DAY[year].call.year if DEICTIC_TO_DAY.key?(year)

        year.to_i
      end

      def parse_month
        return DateTime.current.month if month.nil?

        validate!(month, VALID_MONTH_VALUES, 'month')

        return DEICTIC_TO_DAY[month].call.month if DEICTIC_TO_DAY.key?(month)
        return MONTHS_OF_YEAR.index(month) + 1 if MONTHS_OF_YEAR.include?(month)
        return MONTHS_OF_YEAR_ABBR.index(month) + 1 if MONTHS_OF_YEAR_ABBR.include?(month)

        month.to_i
      end

      def parse_day
        return DateTime.current.day if day.nil?

        validate!(day, VALID_DAY_VALUES, 'day')

        return DEICTIC_TO_DAY[day].call.day if DEICTIC_TO_DAY.key?(day)
        return DAYS_OF_WEEK.index(day) + 1 if DAYS_OF_WEEK.include?(day)
        return DAYS_OF_WEEK_ABBR.index(day) + 1 if DAYS_OF_WEEK_ABBR.include?(day)

        day.to_i
      end

      def day_range(day_name, direction = :forward, include_current = false)
        target_day  = DAYS_OF_WEEK.index(day_name)  # 0-index
        current_day = Time.zone.today.wday - 1 # 0-index

        difference = (target_day - current_day) % 7

        case direction
        when :forward
          difference = 7 if difference.zero? && !include_current
        when :backward
          difference -= 7 unless difference.zero? && include_current
        end

        target_date = Time.zone.today + difference.days
        target_date.bod..target_date.eod
      end

      def month_range(month, direction = :forward, include_current = false)
        target_month  = MONTHS_OF_YEAR.index(month) # 0-index
        current_month = Time.zone.today.month - 1   # 0-index

        difference = (target_month - current_month) % 12

        case direction
        when :forward
          difference = 12 if difference.zero? && !include_current
        when :backward
          difference -= 12 unless difference.zero? && include_current
        end

        target_date = Time.zone.today + difference.months
        target_date.bom.bod..target_date.eom.eod
      end

      def validate!(input, valid_values, type)
        return if skip_validations?

        raise InvalidPeriod,
              "Invalid #{type}: #{input}" unless valid_values.include?(year)
      end

      def skip_validations?
        @skip_validations
      end
    end
  end
end

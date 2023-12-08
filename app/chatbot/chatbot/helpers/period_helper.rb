module Chatbot
  module Helpers
    class PeriodHelper
      InvalidPeriod = Class.new(Lansky::DisplayableError)

      DAYS_OF_WEEK   = %w[monday tuesday wednesday thursday
                          friday saturday sunday]

      MONTHS_OF_YEAR = %w[january february march april may june july august
                          september october november december]

      DEICTIC_TO_DAY = {
        'yesterday'  => ->(*) { Time.zone.yesterday.bod},
        'today'      => ->(*) { Time.zone.today.bod},
        'tomorrow'   => ->(*) { Time.zone.tomorrow.bod },

        'last week'  => ->(*) { Time.zone.today.prev_week.bod},
        'this week'  => ->(*) { Time.zone.today.bow .bod},
        'next week'  => ->(*) { Time.zone.today.next_week.bod},

        'last month' => ->(*) { Time.zone.today.prev_month.bom.bod},
        'this month' => ->(*) { Time.zone.today.bom.bod},
        'next month' => ->(*) { Time.zone.today.next_month.bom.bod},

        'last year'  => ->(*) { Time.zone.today.prev_year.boy.bod},
        'this year'  => ->(*) { Time.zone.today.boy.bod},
        'next year'  => ->(*) { Time.zone.today.next_year.boy.bod},
      }

      VALID_DAY_VALUES = [
        DAYS_OF_WEEK,
        DAYS_OF_WEEK.map { |day| day[0..2] },
        ('1'..'31').to_a,
        ['today', 'yesterday', 'tomorrow'],
        ['this ', 'last ', 'next '].product(DAYS_OF_WEEK).map(&:join)
      ].flatten.freeze

      VALID_WEEK_VALUES = [
        ['this week', 'last week', 'next week'],
        ['week 1', 'week 2', 'week 3', 'week 4'],
      ].flatten.freeze

      VALID_MONTH_VALUES = [
        MONTHS_OF_YEAR,
        MONTHS_OF_YEAR.map { |month| month[0..2] },
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

          if VALID_DAY_VALUES.include?(input)
            day = input
          elsif VALID_WEEK_VALUES.include?(input)
            week = input
          elsif VALID_MONTH_VALUES.include?(input)
            month = input
          elsif VALID_YEAR_VALUES.include?(input)
            year = input
          else
            raise ArgumentError, "Invalid period: #{input}"
          end

          parse_period(day:, week:, month:, year:, **options)
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

        @include_current = params[:include_current] || false
        @direction       = params[:direction] || :forward
      end

      def parse_period
        Models::Period.new(period_start:, period_end: DateTime.current)
      end

      private

      attr_reader :day, :week, :month, :year, :include_current, :direction

      def period_start
        DateTime.new(parsed_year, parsed_month, parsed_day)
      end

      def parsed_year
        return DateTime.current.year unless year

        if year.to_i.to_s == year
          year.to_i
        else
          DEICTIC_TO_PERIOD_START[year].call
        end
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
    end
  end
end

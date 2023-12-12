module Lansky
  class FlexibleDate
    class Interpreter
      class << self
        def to_period(flex_date, **options)
          new(**flex_date.to_h, **options).to_period
        end

        private :new
      end

      def initialize(day:, week:, month:, year:, **options)
        @day   = Day.new   day,   parent_present: week.present?, **options
        @week  = Week.new  week,                                 **options
        @month = Month.new month, parent_present: year.present?, **options
        @year  = Year.new  year,                                 **options

        @duration = options[:duration]
      end

      def to_period
        Lansky::Period.new(period_start, period_end)
      end

      def period_start
        datetime = DateTime.current.bod

        datetime
          .then { |dt| year.resolve(dt) }
          .then { |dt| month.resolve(dt) }
          .then { |dt| week.resolve(dt) }
          .then { |dt| day.resolve(dt) }
      end

      def period_end
        case
        when duration.present? then period_start + duration
        when day.present? then period_start + 1.day
        when week.present? then period_start + 1.week
        when month.present? then period_start + 1.month
        else
          period_start + 1.year
        end
      end

      private

      attr_reader :day, :week, :month, :year, :duration
    end
  end
end

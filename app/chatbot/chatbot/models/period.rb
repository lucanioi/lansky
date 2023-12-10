module Chatbot
  module Models
    class Period
      attr_reader :period_start, :period_end

      DAY_DURATION   = (1.day - 1.seconds).to_f..1.day.to_f
      WEEK_DURATION  = (1.week - 1.seconds).to_f..1.week.to_f
      MONTH_DURATION = (28.days - 1.second).to_f..31.days.to_f
      YEAR_DURATION  = (1.year - 1.seconds).to_f..1.year.to_f

      def initialize(period_start:, period_end:)
        @period_start = period_start.to_time
        @period_end = period_end.to_time
      end

      def range
        period_start..period_end
      end

      def duration
        period_end - period_start
      end

      def day?
        DAY_DURATION.cover?(duration)
      end

      def week?
        WEEK_DURATION.cover?(duration)
      end

      def month?
        MONTH_DURATION.cover?(duration)
      end

      def year?
        YEAR_DURATION.cover?(duration)
      end

      def calender_day?
        day? && period_start.hour.zero? && period_start.min.zero?
      end

      def calender_week?
        week? && period_start.wday == 1
      end

      def calender_month?
        month? && period_start.day == 1
      end

      def calender_year?
        year? && period_start.day == 1 && period_start.month == 1
      end
    end
  end
end

module Chatbot
  module Helpers
    module DateTimeHelper
      InvalidPeriod = Class.new(Lansky::DisplayableError)

      DAY_DURATION = (1.day - 1.seconds).to_f..1.day.to_f
      WEEK_DURATION = (1.week - 1.seconds).to_f..1.week.to_f
      MONTH_DURATION = (28.days - 1.second).to_f..31.days.to_f
      YEAR_DURATION = (1.year - 1.seconds).to_f..1.year.to_f

      module_function

      # in the format 'Mon, 01 Jan 2020' for specific days
      # in the format 'week starting Mon, 01/Jan' for weeks
      # in the format 'January 2020' for months
      # in the format '2020' for years
      # in the format 'Mon, 01 Jan 2020 - Sun, 31 Jan 2020' for other periods
      def format_period(period)
        case
        when period.calender_day? then period.period_start.strftime('%a, %d %b %Y')
        when period.calender_week? then period.period_start.strftime("week starting %a, %d/%b")
        when period.calender_month? then period.period_start.strftime('%B %Y')
        when period.calender_year? then period.period_start.strftime('%Y')
        else
          start_name = period.period_start.strftime('%a, %d %b %Y')
          end_name = period.period_end.strftime('%a, %d %b %Y')
          "#{start_name} - #{end_name}"
        end
      end
    end
  end
end

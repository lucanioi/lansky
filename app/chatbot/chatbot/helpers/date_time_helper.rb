module Chatbot
  module Helpers
    module Helpers::DateTimeHelper
      InvalidPeriod = Class.new(Lansky::DisplayableError)

      DAYS_OF_WEEK   = %w[monday tuesday wednesday thursday friday saturday sunday]
      MONTHS_OF_YEAR = %w[january february march april may june july august september october november december]

      STRING_TO_RANGE = {
        'yesterday'  => ->(*) { Date.yesterday.bod ..Date.yesterday.eod },
        'today'      => ->(*) { Time.zone.today.bod..Time.zone.today.eod },
        'tomorrow'   => ->(*) { Date.tomorrow.bod  ..Date.tomorrow.eod },

        'last week'  => ->(*) { Time.zone.today.prev_week.bod..Time.zone.today.prev_week.eow.eod },
        'this week'  => ->(*) { Time.zone.today.bow .bod     ..Time.zone.today.eow.eod },
        'next week'  => ->(*) { Time.zone.today.next_week.bod..Time.zone.today.next_week.eow.eod },

        'last month' => ->(*) { Time.zone.today.prev_month.bom.bod..Time.zone.today.prev_month.eom.eod },
        'this month' => ->(*) { Time.zone.today.bom.bod           ..Time.zone.today.eom.eod },
        'next month' => ->(*) { Time.zone.today.next_month.bom.bod..Time.zone.today.next_month.eom.eod },

        'last year'  => ->(*) { Time.zone.today.prev_year.boy.bod..Time.zone.today.prev_year.eoy.eod },
        'this year'  => ->(*) { Time.zone.today.boy.bod          ..Time.zone.today.eoy.eod },
        'next year'  => ->(*) { Time.zone.today.next_year.boy.bod..Time.zone.today.next_year.eoy.eod },
      }

      STRING_TO_RANGE.merge!(
        DAYS_OF_WEEK.product([nil]).to_h { |day, _|
          [day.downcase, ->(*options) { day_range(day, *options) }]
        },
        MONTHS_OF_YEAR.product([nil]).to_h { |month, _|
          [month.downcase, ->(*options) { month_range(month, *options) }]
        }
      )

      VALID_PERIOD_NAMES = (STRING_TO_RANGE.keys + DAYS_OF_WEEK + MONTHS_OF_YEAR).freeze

      DAY_DURATION = (1.day - 1.seconds).to_f..1.day.to_f
      WEEK_DURATION = (1.week - 1.seconds).to_f..1.week.to_f
      MONTH_DURATION = (28.days - 1.second).to_f..31.days.to_f
      YEAR_DURATION = (1.year - 1.seconds).to_f..1.year.to_f

      module_function

      def parse_period(period_string, direction: nil, include_current: false)
        raise(InvalidPeriod, 'Invalid period') if period_string.blank?
        raise(InvalidPeriod, "Invalid period: #{period_string}") unless VALID_PERIOD_NAMES.include?(period_string)

        STRING_TO_RANGE[period_string].call(direction, include_current)
      end

      # in the format 'Mon, 01 Jan 2020' for specific days
      # in the format 'week starting Mon, 01/Jan' for weeks
      # in the format 'January 2020' for months
      # in the format '2020' for years
      # in the format 'Mon, 01 Jan 2020 - Sun, 31 Jan 2020' for other periods
      def format_period(period_range)
        case period_range.end - period_range.begin.to_time
        in duration if DAY_DURATION.cover?(duration)
          period_range.begin.strftime('%a, %d %b %Y')
        in duration if WEEK_DURATION.cover?(duration)
          period_range.begin.strftime("week starting %a, %d/%b")
        in duration if MONTH_DURATION.cover?(duration) && period_range.begin.day == 1
          period_range.begin.strftime('%B %Y')
        in duration if YEAR_DURATION.cover?(duration) && period_range.begin.day == 1 && period_range.begin.month == 1
          period_range.begin.strftime('%Y')
        else
          start_name = period_range.begin.strftime('%A, %d %b %Y')
          end_name = period_range.end.strftime('%A, %d %b %Y')
          "#{start_name} - #{end_name}"
        end
      end

      ###################
      # private methods #
      ###################

      def day_range(day, direction = :forward, include_current = false)
        target_day  = DAYS_OF_WEEK.index(day) # 0-index
        current_day = Time.zone.today.wday - 1     # 0-index

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
        current_month = Time.zone.today.month - 1        # 0-index

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

      private_class_method :day_range, :month_range
    end
  end
end

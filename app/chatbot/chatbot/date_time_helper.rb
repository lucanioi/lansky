module Chatbot
  module DateTimeHelper
    DAYS_OF_WEEK   = %w[monday tuesday wednesday thursday friday saturday sunday]
    MONTHS_OF_YEAR = %w[january february march april may june july august september october november december]

    STRING_TO_RANGE = {
      'yesterday'  => ->(*) { Date.yesterday..Date.yesterday.eod },
      'today'      => ->(*) { Date.today    ..Date.today.eod },
      'tomorrow'   => ->(*) { Date.tomorrow ..Date.tomorrow.eod },

      'last week'  => ->(*) { Date.today.prev_week..Date.today.prev_week.eow.eod },
      'this week'  => ->(*) { Date.today.bow      ..Date.today.eow.eod },
      'next week'  => ->(*) { Date.today.next_week..Date.today.next_week.eow.eod },

      'last month' => ->(*) { Date.today.prev_month.bom..Date.today.prev_month.eom.eod },
      'this month' => ->(*) { Date.today.bom           ..Date.today.eom.eod },
      'next month' => ->(*) { Date.today.next_month.bom..Date.today.next_month.eom.eod },

      'last year'  => ->(*) { Date.today.prev_year.boy..Date.today.prev_year.eoy.eod },
      'this year'  => ->(*) { Date.today.boy          ..Date.today.eoy.eod },
      'next year'  => ->(*) { Date.today.next_year.boy..Date.today.next_year.eoy.eod },
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
      raise('no period specified') if period_string.blank?
      raise("invalid period: #{period_string}") unless VALID_PERIOD_NAMES.include?(period_string)

      STRING_TO_RANGE[period_string].call(direction, include_current)
    end

    # in the format 'Mon, 01 Jan 2020' for specific days
    # in the format 'week starting Mon, 01/Jan' for weeks
    # in the format 'January 2020' for months
    # in the format '2020' for years
    def format_period(period_range)
      case period_range.end - period_range.begin.to_datetime
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
      target_day  = DAYS_OF_WEEK.index(day) # 0-indexed
      current_day = Date.today.wday - 1     # 0-indexed

      difference = (target_day - current_day) % 7
      difference = 7 if difference.zero? && !include_current
      difference = difference - 7 if direction == :backward

      target_date = Date.today + difference.days
      target_date..target_date.eod
    end

    def month_range(month, direction = :forward, include_current = false)
      target_month  = MONTHS_OF_YEAR.index(month) # 0-indexed
      current_month = Date.today.month - 1        # 0-indexed

      difference = (target_month - current_month) % 12
      difference = 12 if difference.zero? && !include_current
      difference = difference - 12 if direction == :backward

      target_date = Date.today + difference.months
      target_date.bom..target_date.eom.eod
    end

    private_class_method :day_range, :month_range
  end
end

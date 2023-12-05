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
        [day.downcase, ->(direction) { day_range(day, direction) }]
      },
      MONTHS_OF_YEAR.product([nil]).to_h { |month, _|
        [month.downcase, ->(direction) { month_range(month, direction) }]
      }
    )

    module_function

    def parse_period(period_string, direction: nil)
      raise('invalid period') unless STRING_TO_RANGE.key?(period_string)

      STRING_TO_RANGE[period_string].call(direction)
    end

    ###################
    # private methods #
    ###################

    def day_range(day, direction = :forward)
      target_day  = DAYS_OF_WEEK.index(day) # 0-indexed
      current_day = Date.today.wday - 1     # 0-indexed

      difference = (target_day - current_day) % 7
      difference = 7 if difference.zero?
      difference = difference - 7 if direction == :backward

      target_date = Date.today + difference.days
      target_date..target_date.eod
    end

    def month_range(month, direction = :forward)
      target_month  = MONTHS_OF_YEAR.index(month) # 0-indexed
      current_month = Date.today.month - 1        # 0-indexed

      difference = (target_month - current_month) % 12
      difference = 12 if difference.zero?
      difference = difference - 12 if direction == :backward

      target_date = Date.today + difference.months
      target_date.bom..target_date.eom.eod
    end

    private_class_method :day_range, :month_range
  end
end

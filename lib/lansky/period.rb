module Lansky
  class Period
    class << self
      def from_params(**params)
        Chatbot::Parsers::Date::Parser.parse_from_params(**params)
      end
    end

    def initialize(period_start, period_end)
      @period_start = period_start.to_time
      @period_end = period_end.to_time
    end

    def start
      @period_start
    end

    # using `fin` internally to avoid confusion with `end` keyword
    def end
      @period_end
    end
    alias_method :fin, :end

    def range
      start..fin
    end

    def duration
      fin - start
    end

    # in the format 'Mon, 01 Jan 2020' for specific days
    # in the format 'week starting Mon, 01/Jan' for weeks
    # in the format 'January 2020' for months
    # in the format '2020' for years
    # in the format 'Mon, 01 Jan 2020 - Sun, 31 Jan 2020' for other periods
    def format
      case
      when calendar_day? then start.strftime('%a, %d %b %Y')
      when calendar_week? then start.strftime("week starting %a, %d/%b")
      when calendar_month? then start.strftime('%B %Y')
      when calendar_year? then start.strftime('%Y')
      else
        start_name = start.strftime('%a, %d %b %Y')
        end_name = fin.strftime('%a, %d %b %Y')
        "#{start_name} - #{end_name}"
      end
    end

    def calendar_day?
      first_hour? && duration ==  1.day
    end

    def calendar_week?
      first_hour? && duration == 1.week && start.wday == 1
    end

    def calendar_month?
      first_hour? && first_day? &&  fin == (start.next_month)
    end

    def calendar_year?
      first_hour? && first_day? && first_month? && fin == (start.next_year)
    end

    private

    def first_hour?
      start.hour.zero? && start.min.zero?
    end

    def first_day?
      start.day == 1
    end

    def first_month?
      start.month == 1
    end
  end
end

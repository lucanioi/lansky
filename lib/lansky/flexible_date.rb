module Lansky
  class FlexibleDate
    include Immutable

    attr_reader :day, :week, :month, :year

    def initialize(day: nil, week: nil, month: nil, year: nil)
      @day   = day
      @week  = week
      @month = month
      @year  = year
    end

    def to_period(**options)
      Interpreter.to_period(self, **options)
    end

    def ==(other)
      other.is_a?(self.class) &&
        other.day == day &&
        other.week == week &&
        other.month == month &&
        other.year == year
    end

    def to_h
      {
        day: day,
        week: week,
        month: month,
        year: year
      }
    end
  end
end

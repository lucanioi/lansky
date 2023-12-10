class Period
  attr_reader :period_start, :period_end

  def initialize(period_start, period_end)
    @period_start = period_start.to_time
    @period_end = period_end.to_time
  end

  def start
    period_start
  end
  alias_method :begin, :start

  def end
    period_end
  end

  def range
    period_start..period_end
  end

  def duration
    period_end - period_start
  end

  def calender_day?
    duration == 1.day && first_hour?
  end

  def calender_week?
    duration == 1.week && period_start.wday == 1 && first_hour?
  end

  def calender_month?
    period_end == (period_start.next_month) && first_hour? && first_day?
  end

  def calender_year?
    duration == 1.year && first_hour? && first_day? && first_month?
  end

  def first_hour?
    period_start.hour.zero? && period_start.min.zero?
  end

  def first_day?
    period_start.day == 1
  end

  def first_month?
    period_start.month == 1
  end
end

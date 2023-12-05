require 'date'

class Date
  alias_method :bod, :beginning_of_day
  alias_method :eod, :end_of_day

  alias_method :bow, :beginning_of_week
  alias_method :eow, :end_of_week

  alias_method :bom, :beginning_of_month
  alias_method :eom, :end_of_month

  alias_method :boy, :beginning_of_year
  alias_method :eoy, :end_of_year
end

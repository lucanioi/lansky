module Budgets
  class Find
    include Service

    def call
      Budget.find_by(period_start: period_start, period_end: period_end)
    end

    attr_accessor :period_start, :period_end
  end
end

module Budgets
  class Find
    include Service

    def call
      Budget.find_by(
        user:,
        period_start: (period_range.begin - 0.01.second)..period_range.begin,
        period_end: (period_range.end - 0.01.second)..period_range.end
      )
    end

    attr_accessor :period_range, :user
  end
end

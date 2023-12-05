module Budgets
  class Find
    include Service

    def call
      Budget.find_by(
        user:,
        period_start: (period_start - 0.01.second)..period_start,
        period_end: (period_end - 0.01.second)..period_end
      )
    end

    attr_accessor :period_start, :period_end, :user
  end
end

module Budgets
  class Find
    include Service

    def call
      return find_with_period_range if period_range.present?

      find_active_budget
    end

    private

    # This uses the period_range to find the budget, adding a 0.01 second
    # tolerance. This is because the postgresql precision is different from
    # the ruby precision.
    def find_with_period_range
      Budget.find_by(
        user:,
        period_start: (period_range.begin - 0.01.second)..period_range.begin,
        period_end: (period_range.end - 0.01.second)..period_range.end
      )
    end

    # This assumes that there is only one active budget at a time. If there
    # are multiple active budgets, the last one will be returned. Should be improved.
    def find_active_budget
      current_time = DateTime.current

      user.budgets
          .where('period_start <= ? AND period_end >= ?', current_time, current_time)
          .last
    end

    attr_accessor :period_range, :user
  end
end

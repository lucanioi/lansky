module Budgets
  class Find
    include Runnable

    def run
      return find_with_period if period.present?

      find_active_budget
    end

    private

    def find_with_period
      Budget.find_by(user:, period_start: period.start, period_end: period.end)
    end

    # This assumes that there is only one active budget at a time. If there
    # are multiple active budgets, the last one will be returned. Should be improved.
    def find_active_budget
      current_time = DateTime.current

      user.budgets
          .where('period_start <= ? AND period_end >= ?', current_time, current_time)
          .last
    end

    attr_accessor :period, :user
  end
end

module Budgets
  class Upsert
    include Runnable

    def run
      return budget if budget.save

      raise 'Budget could not be created: ' \
            "#{budget.errors.full_messages.join(", ")}"
    end

    private

    def budget
      @budget ||= Budget.find_or_initialize_by(
        period_start: period_range.begin,
        period_end: period_range.end,
        user: user
      ).tap { |budget| budget.amount_cents = amount_cents }
    end

    attr_accessor :amount_cents, :period_range, :user
  end
end

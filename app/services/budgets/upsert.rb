module Budgets
  class Upsert
    include Service

    def call
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
      ).tap { |budget| budget.amount_in_cents = amount_in_cents }
    end

    attr_accessor :amount_in_cents, :period_range, :user
  end
end

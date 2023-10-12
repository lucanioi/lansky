module Budgets
  class Create
    include Service

    def call
      budget = Budget.new(amount_in_cents:, period_start:, period_end:)

      return budget if budget.save

      raise "Budget could not be created: #{budget.errors.full_messages.join(", ")}"
    end

    attr_accessor :amount_in_cents, :period_start, :period_end
  end
end

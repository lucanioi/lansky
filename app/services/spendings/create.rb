module Spendings
  class Create
    include Service

    def call
      return spending if spending.save

      raise 'Spending could not be created: ' \
            "#{spending.errors.full_messages.join(", ")}"
    end

    private

    def spending
      @spending ||= Spending.new(
        category: category,
        amount_cents: amount_cents,
        spent_at: DateTime.current,
        user: user
      )
    end

    attr_accessor :category, :amount_cents, :user
  end
end

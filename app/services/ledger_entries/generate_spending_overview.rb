module LedgerEntries
  class GenerateSpendingOverview
    include Runnable

    Overview = Struct.new(:total_cents, :spending_details, :recovery_details, keyword_init: true)
    Detail   = Struct.new(:amount, :category, keyword_init: true)

    def run
      Overview.new(total_cents:, spending_details:, recovery_details:)
    end

    private

    def total_cents
      spending_in_period.sum(:amount_cents) - recovery_in_period.sum(:amount_cents)
    end

    def spending_details
      total_spending_by_category
        .map { |category, amount| Detail.new(amount:, category: category.name) }
        .sort_by(&:amount)
        .reverse
    end

    def spending_in_period
      @spending_in_period ||=
        user.ledger_entries.spending.where(recorded_at: period.range)
    end

    def total_spending_by_category
      spending_in_period.group(:category).sum(:amount_cents)
    end

    def recovery_details
      total_recovery_by_category
        .map { |category, amount| Detail.new(amount:, category: category.name) }
        .sort_by(&:amount)
        .reverse
    end

    def recovery_in_period
      @recovery_in_period ||=
        user.ledger_entries.recovery.where(recorded_at: period.range)
    end

    def total_recovery_by_category
      recovery_in_period.group(:category).sum(:amount_cents)
    end

    attr_accessor :user, :period
  end
end

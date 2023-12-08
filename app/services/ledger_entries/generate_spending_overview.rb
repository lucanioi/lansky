module LedgerEntries
  class GenerateSpendingOverview
    include Runnable

    Overview = Struct.new(:total_cents, :details, keyword_init: true)
    Detail   = Struct.new(:amount, :category, keyword_init: true)

    def run
      Overview.new(total_cents:, details:)
    end

    private

    def total_cents
      spending_in_period.sum(:amount_cents)
    end

    def details
      totals_by_category
        .map { |category, amount| Detail.new(amount:, category: category.name) }
        .sort_by(&:amount)
        .reverse
    end

    def spending_in_period
      @spending_in_period ||=
        user.ledger_entries.spending.where(recorded_at: period_range)
    end

    def totals_by_category
      spending_in_period.group(:category).sum(:amount_cents)
    end

    attr_accessor :user, :period_range
  end
end

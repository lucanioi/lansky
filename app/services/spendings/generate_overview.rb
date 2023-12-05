module Spendings
  class GenerateOverview
    include Service

    Overview = Struct.new(:total_in_cents, :details, keyword_init: true)
    Detail   = Struct.new(:amount, :category, keyword_init: true)

    def call
      Overview.new(total_in_cents:, details:)
    end

    private

    def total_in_cents
      spendings_in_period.sum(:amount_in_cents)
    end

    def details
      totals_by_category
        .map { |category, amount| Detail.new(amount:, category: category.name) }
        .sort_by(&:amount)
        .reverse
    end

    def spendings_in_period
      @spendings_in_period ||=
        user.spendings.where(spent_at: period_start..period_end)
    end

    def totals_by_category
      spendings_in_period.group(:category).sum(:amount_in_cents)
    end

    attr_accessor :user, :period_start, :period_end
  end
end

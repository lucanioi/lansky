module Spendings
  class GenerateOverview
    include Service

    Overview = Struct.new(:total_cents, :details, keyword_init: true)
    Detail   = Struct.new(:amount, :category, keyword_init: true)

    def call
      Overview.new(total_cents:, details:)
    end

    private

    def total_cents
      spendings_in_period.sum(:amount_cents)
    end

    def details
      totals_by_category
        .map { |category, amount| Detail.new(amount:, category: category.name) }
        .sort_by(&:amount)
        .reverse
    end

    def spendings_in_period
      @spendings_in_period ||=
        user.spendings.where(spent_at: period_range)
    end

    def totals_by_category
      spendings_in_period.group(:category).sum(:amount_cents)
    end

    attr_accessor :user, :period_range
  end
end

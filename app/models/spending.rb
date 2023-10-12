class Spending < ApplicationRecord
  belongs_to :spending_category
  alias :category :spending_category

  validates :amount_in_cents, presence: true, numericality: { greater_than: 0 }
  validates :spending_category, presence: true
end

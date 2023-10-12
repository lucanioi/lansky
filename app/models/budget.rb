class Budget < ApplicationRecord
  has_many :spendings

  validates :period_start, presence: true
  validates :period_end, presence: true
  validates :amount_in_cents, presence: true, numericality: { greater_than: 0 }
end

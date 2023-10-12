class Budget < ApplicationRecord
  has_many :spendings

  validates :name, presence: true, uniqueness: true
  validates :amount_in_cents, presence: true, numericality: { greater_than: 0 }
end

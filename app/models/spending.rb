class Spending < ApplicationRecord
  belongs_to :category, class_name: 'SpendingCategory', foreign_key: 'spending_category_id'
  belongs_to :user

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
end

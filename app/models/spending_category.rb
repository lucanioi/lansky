class SpendingCategory < ApplicationRecord
  has_many :spendings, class_name: 'Spending', foreign_key: 'spending_category_id'

  validates :name, presence: true, uniqueness: true

  UNCATEGORIZED = 'uncategorized'.freeze

  def uncategorized?
    name == UNCATEGORIZED
  end
end

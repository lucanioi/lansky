class SpendingCategory < ApplicationRecord
  has_many :spendings

  validates :name, presence: true, uniqueness: true
end

class User < ApplicationRecord
  has_many :spendings
  has_many :budgets

  validates :phone, presence: true, numericality: { only_integer: true }
end

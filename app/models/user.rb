class User < ApplicationRecord
  has_many :ledger_entries, dependent: :destroy
  has_many :budgets, dependent: :destroy

  validates :phone, presence: true, numericality: { only_integer: true }

  def test_user?
    test_user
  end
end

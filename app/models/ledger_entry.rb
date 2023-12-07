class LedgerEntry < ApplicationRecord
  belongs_to :category, class_name: 'LedgerCategory', foreign_key: 'ledger_category_id'
  belongs_to :user

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true

  enum entry_type: { spending: 0, recovery: 1 }
end

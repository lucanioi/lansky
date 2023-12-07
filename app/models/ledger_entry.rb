class LedgerEntry < ApplicationRecord
  belongs_to :category, class_name: 'LeedgerCategory', foreign_key: 'ledger_category_id'
  belongs_to :user

  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true

  enum entry_type: { expense: 0, reimbursement: 1 }
end

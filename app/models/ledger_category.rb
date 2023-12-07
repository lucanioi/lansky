class LedgerCategory < ApplicationRecord
  has_many :ledger_entries, class_name: 'LedgerEntry', foreign_key: 'ledger_category_id'

  validates :name, presence: true, uniqueness: true

  UNCATEGORIZED = 'uncategorized'.freeze

  def uncategorized?
    name == UNCATEGORIZED
  end
end

class IndexLedgerEntriesByEntryType < ActiveRecord::Migration[7.1]
  def change
    add_index :ledger_entries, :entry_type
  end
end

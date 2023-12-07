class AddRecordedAtToLedgerEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :ledger_entries, :recorded_at, :datetime
  end
end

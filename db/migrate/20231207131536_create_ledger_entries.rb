class CreateLedgerEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :ledger_entries do |t|
      t.integer :amount_cents
      t.references :ledger_category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :entry_type

      t.timestamps
    end
  end
end

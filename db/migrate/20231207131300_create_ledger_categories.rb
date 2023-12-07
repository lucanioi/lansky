class CreateLedgerCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :ledger_categories do |t|
      t.string :name, index: { unique: true }, null: false

      t.timestamps
    end
  end
end

class CreateSpendings < ActiveRecord::Migration[7.1]
  def change
    create_table :spendings do |t|
      t.references :spending_category, null: false, foreign_key: true
      t.integer :amount_in_cents

      t.timestamps
    end
  end
end

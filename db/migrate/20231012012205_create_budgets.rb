class CreateBudgets < ActiveRecord::Migration[7.1]
  def change
    create_table :budgets do |t|
      t.datetime :period_start
      t.datetime :period_end
      t.integer :amount_in_cents

      t.timestamps
    end
  end
end

class RenameInCentsToCents < ActiveRecord::Migration[7.1]
  def change
    rename_column :budgets, :amount_in_cents, :amount_cents
    rename_column :spendings, :amount_in_cents, :amount_cents
  end
end

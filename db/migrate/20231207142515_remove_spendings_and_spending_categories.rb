class RemoveSpendingsAndSpendingCategories < ActiveRecord::Migration[7.1]
  def change
    drop_table :spendings
    drop_table :spending_categories
  end
end

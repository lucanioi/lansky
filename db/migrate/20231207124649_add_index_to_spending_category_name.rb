class AddIndexToSpendingCategoryName < ActiveRecord::Migration[7.1]
  def change
    add_index :spending_categories, :name, unique: true
  end
end

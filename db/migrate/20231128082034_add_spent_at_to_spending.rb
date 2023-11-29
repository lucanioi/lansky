class AddSpentAtToSpending < ActiveRecord::Migration[7.1]
  def change
    add_column :spendings, :spent_at, :datetime
  end
end

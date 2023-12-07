class AddIndexToUserPhone < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :phone, unique: true
  end
end

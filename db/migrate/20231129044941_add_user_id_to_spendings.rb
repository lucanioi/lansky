class AddUserIdToSpendings < ActiveRecord::Migration[7.1]
  def change
    add_reference :spendings, :user, foreign_key: true
  end
end

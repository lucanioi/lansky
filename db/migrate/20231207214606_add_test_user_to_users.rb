class AddTestUserToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :test_user, :boolean, default: false
  end
end

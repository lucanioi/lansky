class AddChatbotModeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users,
               :chatbot_mode,
               :integer,
               default: User.chatbot_modes[:classic],
               null: false
  end
end

class MessagesChangeUserIdToSid < ActiveRecord::Migration
  def change
    rename_column :messages, :user_id, :sid
    change_column :messages, :sid, :string
  end
end

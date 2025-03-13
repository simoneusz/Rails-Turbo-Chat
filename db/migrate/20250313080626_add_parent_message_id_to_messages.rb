class AddParentMessageIdToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :parent_message_id, :integer
  end
end

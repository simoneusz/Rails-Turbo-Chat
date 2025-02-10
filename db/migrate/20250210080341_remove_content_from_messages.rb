class RemoveContentFromMessages < ActiveRecord::Migration[7.1]
  def change
    remove_column :messages, :content, :text
  end
end

class AddRepliedToMessage < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :replied, :boolean, default: false, null: false
  end
end

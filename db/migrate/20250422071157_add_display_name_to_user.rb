class AddDisplayNameToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :display_name, :string
  end
end

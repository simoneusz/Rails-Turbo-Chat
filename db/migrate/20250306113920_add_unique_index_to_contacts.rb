class AddUniqueIndexToContacts < ActiveRecord::Migration[7.1]
  def change
    add_index :contacts, [:user_id, :contact_id], unique: true
  end
end

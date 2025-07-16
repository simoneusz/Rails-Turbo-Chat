class CreateContactShips < ActiveRecord::Migration[7.1]
  def change
    create_table :contact_ships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: { to_table: :users }
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :contact_ships, [:user_id, :contact_id], unique: true
  end
end
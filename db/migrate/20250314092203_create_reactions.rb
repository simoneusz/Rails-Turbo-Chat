class CreateReactions < ActiveRecord::Migration[7.1]
  def change
    create_table :reactions do |t|
      t.references :message, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :emoji
      t.integer :count, null: false, default: 0

      t.timestamps
    end
  end
end

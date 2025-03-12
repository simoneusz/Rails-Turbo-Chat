class AddConfirmableToUser < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      add_column :users, :confirmation_token, :string
      add_column :users, :confirmed_at, :datetime
      add_column :users, :confirmation_sent_at, :datetime
      add_column :users, :unconfirmed_email, :string
    end
  end
end

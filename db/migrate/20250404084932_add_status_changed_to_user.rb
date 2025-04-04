class AddStatusChangedToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :status_changed, :boolean, default: false
  end
end

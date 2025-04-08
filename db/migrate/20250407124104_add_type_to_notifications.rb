class AddTypeToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :type, :string
  end
end

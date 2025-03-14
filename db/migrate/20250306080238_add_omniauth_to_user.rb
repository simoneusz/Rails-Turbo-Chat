# frozen_string_literal: true

class AddOmniauthToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :avatar_url, :string
  end
end

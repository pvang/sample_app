class AddRememberTokenToUsers < ActiveRecord::Migration

  def change # a migration to add a remember_token to the users table
    add_column :users, :remember_token, :string
    add_index  :users, :remember_token
  end

end

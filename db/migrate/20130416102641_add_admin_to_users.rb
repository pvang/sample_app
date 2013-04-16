# migration to add a boolean admin attribute to users

class AddAdminToUsers < ActiveRecord::Migration
  def change
    # add_column :users, :admin, :boolean
    add_column :users, :admin, :boolean, default: false # added default
  end
end
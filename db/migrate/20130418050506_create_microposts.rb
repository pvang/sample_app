class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    # added since we expect to retrieve all the microposts associated with a given user id in reverse order of creation
    add_index :microposts, [:user_id, :created_at] # adds an index on the user_id and created_at columns
  end
end

class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id

      t.belongs_to :user
      t.belongs_to :friend
      t.timestamps
    end
  end
end

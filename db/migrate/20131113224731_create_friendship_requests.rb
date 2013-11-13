class CreateFriendshipRequests < ActiveRecord::Migration
  def change
    create_table :friendship_requests do |t|
      t.integer :receiver_user_id
      t.integer :sender_user_id
      t.string :status

      t.belongs_to :receiver_user
      t.belongs_to :sender_user
      t.timestamps
    end
  end
end

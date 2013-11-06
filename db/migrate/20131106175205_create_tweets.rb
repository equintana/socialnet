class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet, :limit => 140

      t.timestamps
    end
  end
end

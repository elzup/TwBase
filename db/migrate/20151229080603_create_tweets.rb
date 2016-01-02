class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_id
      t.string :text
      t.integer :user_id
      t.float :lat
      t.float :long
      t.boolean :for_sq
      t.string :keyword

      t.timestamps null: false
    end
  end
end

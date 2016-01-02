class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_id, unique: true
      t.string :text
      t.integer :user_id
      t.float :lat
      t.float :long
      t.boolean :for_sq
      t.string :text_keyword
      t.string :search_word

      t.timestamp :tweeted_at

      t.timestamps null: false
    end
  end
end

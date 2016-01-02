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

    add_index :tweets, :user_id
    add_index :tweets, :created_at
    add_index :tweets, :tweeted_at
  end
end

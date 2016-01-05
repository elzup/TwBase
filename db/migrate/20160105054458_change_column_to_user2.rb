class ChangeColumnToUser2 < ActiveRecord::Migration
  def change
    add_index :tweets, :search_word
    remove_index :tweets, :created_at
  end
end

class ChangeColumnToUser < ActiveRecord::Migration
  def change
    add_index :users, :tid
  end
end

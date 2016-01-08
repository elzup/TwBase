# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  tid         :string
#  screen_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_users_on_tid  (tid)
#

class User < ActiveRecord::Base
  has_many :tweets, :dependent => :delete_all

  def regist(tid, screen_name)
    find_or_create_by(tid: tid) do |user|
      user.screen_name = screen_name
    end
  end
end

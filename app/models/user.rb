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
end

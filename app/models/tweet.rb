# == Schema Information
#
# Table name: tweets
#
#  id         :integer          not null, primary key
#  tweet_id   :string
#  text       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tweet < ActiveRecord::Base
  belongs_to :user
end

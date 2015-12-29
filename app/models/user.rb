class User < ActiveRecord::Base
  has_many :tweets, :dependent => :delete_all
end

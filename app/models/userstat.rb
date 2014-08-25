class Userstat < ActiveRecord::Base
  attr_accessible :permissions, :user_id, :resetCount
end

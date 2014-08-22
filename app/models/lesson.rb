class Lesson < ActiveRecord::Base
  attr_accessible :length, :nextlesson, :order, :platform, :thumbnail, :title, :topic, :url, :related, :topic_id, :lesson_order
end

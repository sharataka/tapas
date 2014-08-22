class Topic < ActiveRecord::Base
  attr_accessible :lesson_id, :name, :order, :topic_order, :topic_slug
end

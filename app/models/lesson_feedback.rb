class LessonFeedback < ActiveRecord::Base
  attr_accessible :feedback, :lesson_id
end

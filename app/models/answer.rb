class Answer < ActiveRecord::Base
  attr_accessible :question_id, :result, :user_id
end

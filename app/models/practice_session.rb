class PracticeSession < ActiveRecord::Base
  attr_accessible :number_correct, :number_incorrect, :number_of_questions, :question_pool, :subjects, :user_id, :question_id
end

class Question < ActiveRecord::Base
  attr_accessible :correct_response, :difficulty, :image, :incorrect_one, :incorrect_three, :incorrect_two, :other_explanation, :prompt, :supplement, :text_explanation, :title, :topic, :video_explanation
end

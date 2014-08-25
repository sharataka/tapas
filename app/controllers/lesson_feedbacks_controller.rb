class LessonFeedbacksController < ApplicationController
	
	def new
		@lesson_feedback = LessonFeedback.new
	end

	def custom_feedback
		lesson_id = params[:lesson_id]
		feedback = params[:feedback]

        if feedback == "1"
        	feedback = "Great and helpful"
        elsif feedback == "2"
        	feedback = "Clear and interesting but not what I'm looking for"
        elsif feedback == "3"
        	feedback = "Okay but wasn't very interesting"
        else
        	feedback = "Unclear or confusing"
        end

		@lesson_feedback = LessonFeedback.new(:lesson_id => lesson_id, :feedback => feedback)
	  	if @lesson_feedback.save
	    	puts "saved"
	  	else
	  		puts "error saving"
		end

		render :nothing => true

	end

	def create
		@lesson_feedback = LessonFeedback.new(params[:lesson_feedback])
	  	if @lesson_feedback.save
	    	puts "saved"
	  	else
	  		puts "error saving"
		end
	end
end

class LessonFeedbacksController < ApplicationController
	
	def new
		@lesson_feedback = LessonFeedback.new
	end


	# Save when a user understands a lesson
	def understand_lesson
		lesson_id = params[:lesson_id]
		user_id = params[:user_id]
		
		# only save if the 2 user id's match
		if current_user.id == user_id.to_i
			@understand = UserUnderstandLesson.new(:lesson_id => lesson_id, :user_id => current_user.id)
			if @understand.save
			else
			end
		end
		render :nothing => true
	end


	# Save user's feedback on a lesson video
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

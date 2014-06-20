class QuestionsController < ApplicationController
	def index
		@questions = Question.all
		puts @questions
	end

	def new
		@question = Question.new
	end

	def create
	  @question = Question.new(params[:question])
	  if @question.save
	    flash[:notice] = "Question has been created."
	    redirect_to @question
	  else
	    flash[:alert] = "Question has not been created."
	    render :action => "new"
		end
	end

	def show
 		@question = Question.find(params[:id])
	end

	def edit
		@question = Question.find(params[:id])
	end

	def update
		@question = Question.find(params[:id])
		if @question.update_attributes(params[:question])
			flash[:notice] = 'Question has been updated.'
			redirect_to @question
		else
			flash[:alert] = 'Question has not been updated.'
			render :action => 'edit'
		end
	end

	def destroy
		@question = Question.find(params[:id])
		@question.destroy
		flash[:notice] = 'Question has been deleted.'
		redirect_to projects_path
	end

	def answer
		@question = Question.find(params[:question_id])
		@student_response = params[:optionsRadios]
		
		# Did student get question correct?
		if @question.correct_response == @student_response
			@result = 'Correct'
		else
			@result = 'Incorrect'
		end

		# Save result to answers table (user_id, question_id, result)
		# Handle if the user has already answered the question (first_response?)
		answer = Answer.new
		answer.question_id = @question.id
		answer.user_id = current_user.id
		answer.result = @result
		answer.save

		# Pull next question to answer

	end


end

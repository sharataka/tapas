class QuestionsController < ApplicationController
	before_filter :user_signed_in, :except => [:landing_page, :about]
	before_filter :is_admin, :only => [:new, :create, :edit, :update, :admin]

	def adminreset
		Answer.where(:user_id => current_user.id).delete_all
		@questions = Question.all
		@questions.each do |question|
			answer = Answer.new
			answer.user_id = current_user.id
			answer.question_id = question.id
			answer.result = "Unanswered"
			answer.title = question.title
			answer.difficulty = question.difficulty
			answer.topic = question.topic_slug
			answer.topic_userfacing_name = question.topic
			answer.save
		end

		userstat = Userstat.where(:user_id => current_user.id).first
		if userstat.resetCount == nil
			userstat.resetCount = 1
		else
			userstat.resetCount = userstat.resetCount + 1
		end

		userstat.save

	end


	def landing_page
		if current_user
			redirect_to "/dashboard"
		end

	end

	def about
	end

	def admin
		if !current_user
			redirect_to new_user_session_path
		else
			@questions = Question.all
			@lessons = Lesson.order("lesson_order asc")
			@topics = Topic.order("topic_order asc")
		end
	end

	def custom_practice
		if params[:error]
			@error_message = "yes"
			@message = "There aren't any questions for the filters you selected! Please pick other filters!"
		end

		@topics = Topic.all

	end

	def decide_start_session
		# if there are enough questions, save session details and redirect to the first question
		
		# Save session details
		session = PracticeSession.new
		session.question_pool = params[:questionpool]
		
		# Include the right number of questions for the session
		if params[:numberQuestions] == "all"
 			session.number_of_questions = 10000
 		else
 			session.number_of_questions = params[:numberQuestions]
 		end
 		session.number_correct = 0
		session.number_incorrect = 0

 		# Process/parse the subjects
		session.subjects = params[:subject].inspect

		puts "Subject(s): #{session.subjects}"
		puts "Question pool: #{session.question_pool}"

		session.user_id = current_user.id

		# Convert subject params into array to retrieve question. Otherwise it's a string
		subject = Array.new
		params[:subject].each do |c|
			subject << c
		end

		# Retrieve first question
		first_question = Answer.where(:topic => subject, :result => params[:questionpool]).first
		if first_question == nil
			# If there arent enough questions, stay on the same page and show a message prompting to change the filters		
			redirect_to "/custom_practice/try_again"
		else			
			# Save the session
			session.save
			
			# Redirect to first question	
			redirect_to "/session/#{session.id}/question/#{first_question.question_id}"
		end
		
	end

	def index
		@questions = Question.all
		@lessons = Lesson.paginate(:page => params[:page], :per_page => 10)



		# Get count of questions answered
		@answers = Answer.where(:user_id => current_user.id, :result => ['Correct', 'Incorrect'])
		
		if @answers.count != 0
			puts @answers
			@correct = 0
			@answers.each do |answer|
				if answer.result == "Correct"
					@correct = @correct + 1
				end
			end
			@total = @answers.count
			@percent_correct =  ((@correct.to_f/@total.to_f) * 100).to_int

		else
			# No answers to review because all Unanswered
		end

		understand = UserUnderstandLesson.where(:user_id => current_user.id)
		@lesson_understand = []
		understand.each do |lesson|
			@lesson_understand << lesson.lesson_id
		end

	end

	def new
		@question = Question.new
	end

	def create
	  @question = Question.new(params[:question])
	  if @question.save
	    flash[:notice] = "Question has been created."
	    topic_object = Topic.find(@question.topic_id)
		@question.topic = topic_object.name
		@question.topic_slug = topic_object.topic_slug
		@question.save
	    redirect_to @question
	  else
	    flash[:alert] = "Question has not been created."
	    render :action => "new"
		end
	end

	def show
 		@question = Question.find(params[:id])
	end

	def session_question
 		@question = Question.find(params[:question_id])
 		@session = params[:session_id]
 		@order = rand(1..@session.to_i)%5
 		if @order == 0
 			@order = 1
 		end
	end

	def edit
		@question = Question.find(params[:id])
	end

	def update
		@question = Question.find(params[:id])
		if @question.update_attributes(params[:question])
			flash[:notice] = 'Question has been updated.'
			topic_object = Topic.find(@question.topic_id)
			@question.topic = topic_object.name
			@question.topic_slug = topic_object.topic_slug
			@question.save
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
		redirect_to "/admin"
	end

	def answer
		@question = Question.find(params[:question_id])
		session = PracticeSession.find(params[:session_id])
		@session = params[:session_id]
		@order = params[:order].to_i
		@student_response = params[:optionsRadios]
		
		if @student_response == nil
			@student_response = params[:freeResponseInput]
		end

		
		# Did student get question correct?
		if @question.correct_response == @student_response
			@result = 'Correct'
			session.number_correct = session.number_correct + 1
		else
			@result = 'Incorrect'
			session.number_incorrect = session.number_incorrect + 1
		end
		session.save

		# Update answer record to reflect student's response
		answer = Answer.where(:question_id => params[:question_id], :user_id => current_user.id).first
		answer.result = @result
		answer.practicesession_id = params[:session_id].to_i
		answer.studentanswer = @student_response
		answer.save
	
		# Convert subject params into array to retrieve question. Otherwise it's a string
		subject_string = session.subjects
		subject_string = subject_string.tr('[]','').tr('""',"").tr(' ','')
		subject = Array.new
		subject = subject_string.split(",")

		# Get the next question. For loop is to ensure student hasn't already answered that quesiton in the same session
		@next_questions = Answer.where(:topic => subject, :result => session.question_pool, :user_id => current_user.id)
		
		@next_questions.each do |question|
			if question.practicesession_id == answer.practicesession_id
				@next_question = nil
			else
				@next_question = Answer.find(question.id)
			end
		end

		if @next_question == nil
			@is_there_next_question = "No"
		else
			@next_question = @next_question.question_id
		end

		# Get associated lessons for question
		associations = Questiontolesson.where(:question_id => @question.id)
		lessons_array = []
		associations.each do |association|
			lessons_array << association.lesson_id
		end
		@lessons = Lesson.where(:id => lessons_array)

	end

	def review
		@answers = Answer.where(:user_id => current_user.id, :practicesession_id => params[:session_id].to_i)
		@session = PracticeSession.find(params[:session_id])
		@correct = @session.number_correct
		@incorrect = @session.number_incorrect
		@total = @correct + @incorrect
		@percent_correct =  ((@correct.to_f/@total.to_f) * 100).to_int
	end

	def review_answer
		@question = Question.find(params[:question_id])
		@answer = Answer.where(:user_id => current_user.id, 
								:question_id => params[:question_id], 
								:practicesession_id => params[:session_id]).first
		@session = params[:session_id]
		
		# Did student get question correct?
		if @question.correct_response == @answer.studentanswer
			@result = 'Correct'
		else
			@result = 'Incorrect'
		end

	end

	def review_all
		@answers = Answer.where(:user_id => current_user.id, :result => ['Correct', 'Incorrect'])
		if @answers.count != 0
			puts @answers
			@correct = 0
			@answers.each do |answer|
				if answer.result == "Correct"
					@correct = @correct + 1
				end
			end
			@total = @answers.count
			@percent_correct =  ((@correct.to_f/@total.to_f) * 100).to_int

		else
			# No answers to review because all Unanswered
		end
	end

	private
	def user_signed_in
		if !current_user
			redirect_to new_user_session_path
		end
	end

	def is_admin
		user = Userstat.where(:user_id => current_user.id).first
		if user == nil
			redirect_to root_path
		elsif user.permissions == "admin"
			# Do nothing since the user is an admin
		else
			user.permissions != "admin"
			redirect_to root_path
		end
	end


end

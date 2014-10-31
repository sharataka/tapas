class QuestionsController < ApplicationController
	before_filter :user_signed_in, :except => [:landing_page, :about, :parsetest]
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

	def nextquestion
		@subject = params[:subject]
		@question_pool = params[:questionpool]
		@session = params[:session]

		# Questions answered in this session
		current_session = Answer.where(:practicesession_id => @session)
		current_session_questions = []
		current_session.each do |question|
			current_session_questions << question.question_id
		end

		# If user selects correct/incorrect questions
		if @question_pool == "Correct" || @question_pool == "Incorrect"
			
			potential = Answer.where(:topic => @subject, :result => @question_pool, :user_id => current_user.id)

			potential_questions = []
			potential.each do |question|
				potential_questions << question.question_id
			end
			

			first_question = nil
			potential_questions.each do |potential_question|
				if current_session_questions.include?(potential_question)
				else
					first_question = potential_question
				end
			end


			if first_question == nil
				redirect_to "/review/#{@session}"
				return
			else
				redirect_to "/session/#{@session}/question/#{first_question}/subject/#{@subject}/pool/#{@question_pool}/"
				return
			end
		
		# Unanswered questions
		else
			answered_questions = []
			all_questions_ids = []

			# Get all questions
			all_questions = Question.where(:topic_slug => @subject)
			all_questions.each do |question|
				all_questions_ids << question.id
			end

			puts "all questions: #{all_questions_ids}"
			
			# Get student's answered questions
			answered_questions = Answer.where(:topic => @subject, :user_id => current_user.id)
			answered_questions_ids = []
			answered_questions.each do |answer|
				answered_questions_ids << answer.question_id
			end

			puts "answered questions: #{answered_questions_ids}"

			# Get first unanswered question
			all_questions_ids.each do |potential_question|
				if answered_questions_ids.include? potential_question
				else
					redirect_to "/session/#{@session}/question/#{potential_question}/subject/#{@subject}/pool/#{@question_pool}/"
					return
				end
			end
			redirect_to "/review/#{@session}"
			return

		end
	end

	def decide_start_session
		# if there are enough questions, save session details and redirect to the first question
		
		question_pool = params[:questionpool]
		subject = params[:subject]

		
		# If user selects correct/incorrect questions
		if question_pool == "Correct" || question_pool == "Incorrect"
			
			first_question = Answer.where(:topic => subject, :result => question_pool, :user_id => current_user.id).first
			if first_question == nil
				redirect_to "/custom_practice/error"
				return
			else
				session = PracticeSession.new
				session.question_id = first_question.question_id
				session.save
				redirect_to "/session/#{session.id}/question/#{first_question.question_id}/subject/#{subject}/pool/#{question_pool}/"
				return
			end

		# Unanswered questions
		else
			answered_questions = []
			all_questions_ids = []

			# Get all questions
			all_questions = Question.where(:topic_slug => subject)
			all_questions.each do |question|
				all_questions_ids << question.id
			end
			puts all_questions_ids

			
			# Get student's answered questions
			answered_questions = Answer.where(:topic => subject, :user_id => current_user.id)
			answered_questions_ids = []
			answered_questions.each do |answer|
				answered_questions_ids << answer.question_id
			end
			puts answered_questions_ids

			# Get first unanswered question
			all_questions_ids.each do |question|
				if answered_questions_ids.include? question
				else
					session = PracticeSession.new
					session.save
					redirect_to "/session/#{session.id}/question/#{question}/subject/#{subject}/pool/#{question_pool}/"
					return
					break
				end
			end

			@error_message = "You don't have any questions left with these filters!"
			redirect_to "/custom_practice/error"
			return

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
 		@subject = params[:subject]
 		@questionpool = params[:questionpool]
 		@session = params[:session_id]
 		
 		@order = rand(1..1000)%5
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
		@order = params[:order].to_i
		@student_response = params[:optionsRadios]
		@question_pool = params[:questionpool]
		@subject = params[:subject]
		@session = params[:session_id]
		
		if @student_response == nil
			@student_response = params[:freeResponseInput]
		end
		
		# Did student get question correct?
		if @question.correct_response == @student_response
			@result = 'Correct'
		else
			@result = 'Incorrect'
		end

		# Update answer record to reflect student's response
		if @question_pool == "Unanswered"
			answer = Answer.new
			answer.result = @result
			answer.title = @question.title
			answer.difficulty = @question.difficulty
			answer.topic_userfacing_name = @question.topic
			answer.studentanswer = @student_response
			answer.user_id = current_user.id
			answer.question_id = @question.id
			answer.topic = @subject
			answer.practicesession_id = @session
			answer.save
		else
			# Student answers an already answered question, just update the response
			answer = Answer.where(:question_id => params[:question_id], :user_id => current_user.id).first
			answer.result = @result
			answer.practicesession_id = @session
			answer.save
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
		@question = 

		@session = PracticeSession.find(params[:session_id])
		
		@correct = 0
		@incorrect = 0
		@answers.each do |answer|
			if answer.result == "Correct"
				@correct = @correct + 1
			else
				@incorrect = @incorrect + 1
			end
		end
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

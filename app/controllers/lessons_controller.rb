class LessonsController < ApplicationController
	before_filter :user_signed_in, :except => []

	def index
		@lessons = Lesson.all
	end

	def new
		@lesson = Lesson.new
	end

	def create
	  @lesson = Lesson.new(params[:lesson])
	  if @lesson.save
	    flash[:notice] = "Lesson has been created."
	    redirect_to @lesson
	  else
	    flash[:alert] = "Lesson has not been created."
	    render :action => "new"
		end
	end

	def show
 		@lesson = Lesson.find(params[:id])
 		@next_lesson = Lesson.where(:order => @lesson.order + 1).first
 		
 		# Is there a next lesson?
 		if @next_lesson == nil
 			@no_next_lesson = true
 		end

 		@related_lessons = Lesson.where(:topic => @lesson.topic).limit(4)

	end

	def edit
		@lesson = Lesson.find(params[:id])
	end

	def update
		@lesson = Lesson.find(params[:id])
		if @lesson.update_attributes(params[:lesson])
			flash[:notice] = 'Lesson has been updated.'
			redirect_to @lesson
		else
			flash[:alert] = 'Lesson has not been updated.'
			render :action => 'edit'
		end
	end

	private
	def user_signed_in
		if !current_user
			redirect_to new_user_session_path
		end
	end

end

class LessonsController < ApplicationController
	before_filter :user_signed_in, :except => []

	def index
		@lessons = Lesson.order("lesson_order asc")
		@topics = Topic.all
	end

	def new
		@lesson = Lesson.new
	end

	def create
	  @lesson = Lesson.new(params[:lesson])
	  if @lesson.save
	    flash[:notice] = "Lesson has been created."
	    redirect_to "/admin"
	  else
	    flash[:alert] = "Lesson has not been created."
	    render :action => "new"
		end
	end

	def show
 		@lesson = Lesson.find(params[:id])
 		@next_lesson = Lesson.where(:id => @lesson.nextlesson).first

 		if @next_lesson.id == @lesson.id
 			@no_next_lesson = true
 		end

 		@related_lessons = Lesson.where("lesson_order > ?", @next_lesson.lesson_order).limit(4)
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

	def destroy
		@lesson = Lesson.find(params[:id])
		@lesson.destroy
		flash[:notice] = 'Lesson has been deleted.'
		redirect_to "/admin"
	end

	private
	def user_signed_in
		if !current_user
			redirect_to new_user_session_path
		end
	end

end

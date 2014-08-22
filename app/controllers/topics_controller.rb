class TopicsController < ApplicationController
before_filter :user_signed_in, :except => []

	def index
		@topics = Topic.order("topic_order asc")
	end

	def new
		@topic = Topic.new
	end

	def create
	  @topic = Topic.new(params[:topic])
	  if @topic.save
	    flash[:notice] = "Topic has been created."
	    redirect_to topics_path
	  else
	    flash[:alert] = "Topic has not been created."
	    render :action => "new"
		end
	end

	def show
 		@topic = Topic.find(params[:id])
 		@lessons = Lesson.where(:topic_id => @topic.id)
	end

	def edit
		@topic = Topic.find(params[:id])
	end

	def update
		@topic = Topic.find(params[:id])
		if @topic.update_attributes(params[:topic])
			flash[:notice] = 'Topic has been updated.'
			redirect_to topics_path
		else
			flash[:alert] = 'Topic has not been updated.'
			render :action => 'edit'
		end
	end

	def destroy
		@topic = Topic.find(params[:id])
		@topic.destroy
		flash[:notice] = 'Topic has been deleted.'
		redirect_to topics_path
	end

	private
	def user_signed_in
		if !current_user
			redirect_to new_user_session_path
		end
	end
end

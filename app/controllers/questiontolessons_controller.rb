class QuestiontolessonsController < ApplicationController
	before_filter :user_signed_in, :except => []
	
	def index
		@questiontolessons = Questiontolesson.order("question_id ASC")
	end

	def new
		@questiontolesson = Questiontolesson.new
	end

	def create
	  @questiontolesson = Questiontolesson.new(params[:questiontolesson])
	  if @questiontolesson.save
	    flash[:notice] = "Questiontolesson has been created."
	    redirect_to questiontolessons_path
	  else
	    flash[:alert] = "Questiontolesson has not been created."
	    render :action => "new"
		end
	end

	def show
 		@questiontolesson = Questiontolesson.find(params[:id])
	end

	def edit
		@questiontolesson = Questiontolesson.find(params[:id])
	end

	def update
		@questiontolesson = Questiontolesson.find(params[:id])
		if @questiontolesson.update_attributes(params[:questiontolesson])
			flash[:notice] = 'Questiontolesson has been updated.'
			redirect_to @questiontolesson
		else
			flash[:alert] = 'Questiontolesson has not been updated.'
			render :action => 'edit'
		end
	end

	def destroy
		@questiontolesson = Questiontolesson.find(params[:id])
		@questiontolesson.destroy
		flash[:notice] = 'questiontolesson has been deleted.'
		redirect_to questiontolessons_path
	end

	private
	def user_signed_in
		if !current_user
			redirect_to new_user_session_path
		end
	end

end

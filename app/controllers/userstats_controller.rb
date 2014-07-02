class UserstatsController < ApplicationController
	before_filter :user_signed_in, :except => []


	def index
		@userstats = Userstat.all
	end

	def new
		@userstat = Userstat.new
	end

	def create
	  @userstat = Userstat.new(params[:userstat])
	  if @userstat.save
	    flash[:notice] = "Userstat has been created."
	    redirect_to @userstat
	  else
	    flash[:alert] = "Userstat has not been created."
	    render :action => "new"
		end
	end

	def show
 		@userstat = Userstat.find(params[:id])
 		@user = User.find(@userstat.user_id)
	end

	def edit
		@userstat = Userstat.find(params[:id])
	end

	def update
		@userstat = Userstat.find(params[:id])
		if @userstat.update_attributes(params[:userstat])
			flash[:notice] = 'Userstat has been updated.'
			redirect_to @userstat
		else
			flash[:alert] = 'Userstat has not been updated.'
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

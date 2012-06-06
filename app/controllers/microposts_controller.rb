class MicropostsController < ApplicationController
	before_filter :authenticate
	before_filter :authorized_user, :only => :destroy
	def create
		@micropost = current_user.microposts.create(params[:micropost])
		if @micropost.save
			flash[:success] = "Micropost created"
			redirect_to root_path
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to(root_path)
	end

	def authorized_user
		@micropost = current_user.microposts.find_by_id(params[:id])
		redirect_to(root_path) if @micropost.nil?
	end
end
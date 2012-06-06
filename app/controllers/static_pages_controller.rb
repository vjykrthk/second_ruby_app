class StaticPagesController < ApplicationController
  def home
  	@title = "Home" 
    if signed_in? 
      @micropost = Micropost.new 
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def help
  	@title = "Help"
  end

  def about
  	@title = "About" 	
  end

  def contact
  	@title = "Contact" 	
  end

end

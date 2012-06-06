require 'spec_helper'

describe "Microposts" do
  describe "Creation" do
  	before(:each) do
  		user = Factory(:user)
  		visit signin_path
  		fill_in :email, 	:with => user.email
  		fill_in :password, 	:with => user.password
  		click_button 
  	end
  	describe "Failure" do
  		it "Should not create a micropost" do
	  		lambda do
	  			visit root_path
	  			fill_in :micropost_content, :with => ""
	  			click_button
	  			response.should render_template('static_pages/home')
	  			response.should have_selector("div#error_messages")
	  		end.should_not change(Micropost, :count)
	  	end
  	end
  	describe "Success" do
  		it "Should create a new micropost" do
	  		content = "there your areeee"
	  		lambda do
	  			visit root_path
	  			fill_in :micropost_content, :with => content
	  			click_button
	  			response.should have_selector("span.content", :content => content)
	  		end.should change(Micropost, :count).by(1)
	  	end
  	end
  end
end

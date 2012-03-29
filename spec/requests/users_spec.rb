require 'spec_helper'

describe "Sign Up" do
	describe "failure" do
		it "Should not create new user " do
			lambda do
				visit signup_path
					fill_in :Name,			:with => ''
					fill_in :Email, 		:with => ''
					fill_in :password, 		:with => ''
					fill_in :confirmation,	:with => ''
				click_button
				response.should have_selector("div#error_messages")
			end.should_not change(User, :count)
		end
	end

	describe "failure" do
		it "Should not create new user " do
			lambda do
				visit signup_path
					fill_in :Name,			:with => 'Vijay karthik'
					fill_in :Email, 		:with => 'kdkd@ddd.com'
					fill_in :password, 		:with => 'jjjjjj'
					fill_in :confirmation,	:with => 'jjjjjj'
				click_button
				response.should have_selector("div.flash")
			end.should change(User, :count).by(1)
		end
	end

end

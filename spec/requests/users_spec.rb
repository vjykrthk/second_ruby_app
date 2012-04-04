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

	describe "signin/signout" do
		describe "failure" do
			it "Should not signin user upon failure" do
				visit signin_path
				fill_in :email, :with => ""
				fill_in :password, :with => ""
				click_button
				response.should have_selector("div.flash.error", :content => "Invalid")
			end
		end
		describe "success" do
			it "Should signin user upon sigin and signout upon signout" do
				user = Factory(:user)
				visit signin_path
				fill_in :email, :with => user.email
				fill_in :password, :with => user.password
				click_button
				controller.should be_signed_in
				visit signout_path
				controller.should_not be_signed_in
			end
		end
	end

end

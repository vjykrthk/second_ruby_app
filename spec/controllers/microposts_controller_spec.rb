require 'spec_helper'

describe MicropostsController do
	render_views
	describe "access control" do
		it "Should deny access to 'create'" do
			post :create
			response.should redirect_to(signin_path)
		end

		it "Should deny access to 'destroy'" do
			delete :destroy, :id => 1
			response.should redirect_to(signin_path)
		end
	end

	describe "Post 'create'" do
		before(:each) do
			@user = test_sign_in(Factory(:user))
		end
		describe "failure" do
			before(:each) do
				@attr = { :content => "" }
			end

			it "Should not create a micropost" do
				lambda do
					post :create, :micropost => @attr
				end.should_not change(Micropost, :count)
			end

			it "Should redirect to home page" do
				post :create, :micropost => @attr
				response.should render_template('pages/home')
			end
		end
		describe "success" do
			before(:each) do
				@attr = { :content => "Fooo bardaddddd"}
			end

			it "Should create a micropost given right attributes" do
				lambda do
					post :create, :micropost => @attr
				end.should change(Micropost, :count).by(1)
			end

			it "Should redirect to home page" do
				post :create, :micropost => @attr
				response.should redirect_to(root_path)
			end

			it "Should show the flash message" do
				post :create, :micropost => @attr
				flash[:success].should =~ /micropost created/i
			end
		end
	end

	describe "delete micropost" do
		describe "unauthorized users" do
			before(:each) do
				@user = Factory(:user)
				wrong_user = Factory(:user, :email => Factory.next(:email))
				test_sign_in(wrong_user)
				@micropost = Factory(:micropost, :user => @user)
			end
			it "deny access" do
				delete :destroy, :id => @micropost
				response.should redirect_to(root_path) 
			end
		end
		describe "authorized users" do
			before(:each) do
				@user = Factory(:user)
				test_sign_in(@user)
				@micropost = Factory(:micropost, :user => @user)
			end

			it "Should delete the micropost" do
				lambda do
					delete :destroy, :id => @micropost
				end.should change(Micropost, :count).by(-1)
			end
		end
	end
end
require 'spec_helper'

describe RelationshipsController do
	describe "access control" do
		it "Should deny access create relationship" do
			post :create
			response.should redirect_to(signin_path)
		end
		it "Should deny access delete relationship" do
			delete :destroy, :id => 1
			response.should redirect_to(signin_path)
		end
	end

	describe "Post 'create'" do
		before(:each) do
			@user = test_sign_in(Factory(:user))
			@followed = Factory(:user, :email => Factory.next(:email))
		end
		it "Should create new relationship" do
			lambda do
				post :create, :relationship => { :followed_id => @followed }
				response.should be_redirect
			end.should change(Relationship, :count).by(1)
		end
	
		it "Should create a relationship using ajax" do
			lambda do
				xhr :post, :create, :relationship => { :followed_id => @followed}
				response.should be_success
			end.should change(Relationship, :count).by(1)
		end
	end
	describe "Delete 'destroy'" do
		before(:each) do
			@user = test_sign_in(Factory(:user))
			@followed = Factory(:user, :email => Factory.next(:email))
			@user.follow!(@followed)
			@relationship = @user.relationships.find_by_followed_id(@followed)
		end

		it "Should delete relationships" do
			lambda do
				delete :destroy, :id => @relationship
				response.should be_redirect
			end.should change(Relationship, :count).by(-1)
		end
		it "Should delete a relationship using ajax" do
			lambda do
				xhr :delete, :destroy, :id => @relationship
				response.should be_success
			end.should change(Relationship, :count).by(-1)
		end
	end
end
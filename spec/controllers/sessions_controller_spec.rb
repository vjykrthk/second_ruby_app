require 'spec_helper'

describe SessionsController do
  render_views
  describe "GET 'new'" do
  	it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "Should have the right title" do
    	get :new
    	response.should have_selector("title", :content => 'Sign in')
    end
  end

  describe "POST 'create'" do

    describe "Invalid user" do
        before(:each) do
          @attr = {:email => '', :password => ''}
        end

        it "Should re-render the new page" do
          post :create, :sessions=>@attr
          response.should render_template('new')
        end

        it "Should have the right title" do
          post :create, :sessions=>@attr
          response.should have_selector('title', :content => 'Sign in')
        end

        it "Should have the right flash error message" do
          post :create, :sessions=>@attr
          flash.now[:error] =~ /invalid/i
        end
    end

    describe "Valid user" do
      before(:each) do
        @user = Factory(:user)
        @attr = {:email => @user.email, :password => @user.password}
      end

      it "Should sign in upon valid email/password" do
        post:create, :sessions => @attr
        controller.current_user == @user
        controller.should be_signed_in
      end

      it "Should re-direct to user page" do
        post:create, :sessions => @attr
        response.should redirect_to(user_path(@user))
      end
    end

    describe "Delete 'destroy'" do
      before(:each) do
        @user = Factory(:user)
      end

      it "Should sign out user" do
        test_sign_in(@user)
        delete:destroy
        controller.should_not be_signed_in
        response.should redirect_to(root_path)
      end
    end
  end

end

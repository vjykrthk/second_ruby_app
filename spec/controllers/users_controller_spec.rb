require 'spec_helper'

describe UsersController do
	render_views

  describe "GET 'new'" do


    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "Should have the right title" do
    	get 'new'
    	response.should have_selector('title', :content => 'Sign Up') 
    end

    
  end

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end

    it "Should be successfull" do
      get :show, :id => @user
      response.should be_success
    end

    it "Should find the right user" do
      get :show, :id => @user
      assigns(:user) == @user
    end

    it "Should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "Should have the right header title" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "Should have the right image class" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

end

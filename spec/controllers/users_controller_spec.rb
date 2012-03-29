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

  describe "POST 'create' on failure" do
    before(:each) do
      @attr = {:name => '', :email => '', :password => '', :password_confirmation => ''}
    end

    it "Should not insert into database on failure" do
      lambda do
        post :create, :user => @attr
      end.should_not change(User, :count)
    end

    it "Should have right title" do
      post :create, :user => @attr
      response.should have_selector('title', :content => 'Sign Up')
    end  

    it "Should have right title" do
      post :create, :user => @attr
      response.should render_template('new')
    end

  end

  describe "POST 'create' on success" do
    before(:each) do
      @attr = {:name => 'vijay karthik', :email => 'kdkd@dd.com', :password => 'dddddd', :password_confirmation => 'dddddd'}
    end

    it "Should create a new user in database" do
      lambda do
        post :create, :user => @attr
      end.should change(User, :count).by(1)
    end

    it "Should create a new user in database" do
      post :create, :user => @attr
      response.should redirect_to(user_path(assigns(:user)))
    end

    it "Should have the right flash message" do
      post :create, :user => @attr
      flash[:success].should =~ /welcome to second app/i
    end 

  end

end

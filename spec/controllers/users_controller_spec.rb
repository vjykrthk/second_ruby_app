require 'spec_helper'

describe UsersController do
	render_views

  describe "GET 'index'" do
    
    describe "non-signed in users" do
      it "Should deny access" do
        get 'index'
        response.should redirect_to(signin_path)
        flash[:notice] =~ /sign in/i
      end
    end

    describe "Signed users" do
      before (:each) do
        @user = test_sign_in(Factory(:user))
        first_user = Factory(:user, :name => 'Dillon', :email => 'dillon@example.com')
        second_user = Factory(:user, :name => 'bobby', :email => 'bobby@example.com')

        @user = [@user, first_user, second_user]

        30.times do
          @user << Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
        end

      end

      it "Should be success" do
        get 'index'
        response.should be_success
      end

      it "Should have the right title" do
        get 'index'
        response.should have_selector('title', :content => 'All users')
      end

      it "Should have list of users" do
        get 'index'
        @user[0..2].each do |user|
          response.should have_selector('li', :content => user.name)
        end
      end
 
      it "Should paginate users" do
        get 'index'
        response.should have_selector('div.pagination')
        response.should have_selector('span.disabled', :content => 'Previous')
        response.should have_selector('a', :href => '/users?page=2', :content => '2')
        response.should have_selector('a', :href => '/users?page=2', :content => 'Next')
      end


    end
  end

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

    it "Should show user microposts" do
      @mp1 = Factory(:micropost, :user => @user, :content => "Foobar Foobar")
      @mp2 = Factory(:micropost, :user => @user, :content => "bazbar bazbar")
      get :show, :id => @user
      response.should have_selector("span.content", :content => @mp1.content)
      response.should have_selector("span.content", :content => @mp2.content)
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

    it "Should sigin the user upon successfull signup" do
      post :create, :user => @attr
      controller.should be_signed_in
    end

  end

  describe "GET 'edit' on success" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "Should be successfully render the page" do
      get :edit, :id => @user
      response.should be_success
    end

    it "Should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => 'Edit user')
    end

    it "Should have a link to change the gravatar image" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector('a', :href => gravatar_url, :content => 'Change')
    end
 
  end

  describe "PUT 'update'" do
    before(:each) do
       @user = Factory(:user)
       test_sign_in(@user)
    end 
    describe "failure" do
      before(:each) do
        @attr = { :email => '', :password => '', :password_confirmation => ''} 
      end
      it "Should render the edit page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      it "Should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector('title', :content => 'Edit user')
      end
    end

    describe "success" do
      before(:each) do
        @attr = { :name => 'New name', :email => 'new@example.com', :password => 'bazbar', :password_confirmation => 'bazbar' }
      end

      it "Should change the users attribute" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "Should redirect to the users page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "Should have flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end 
    end
  end
  describe "Authenticate edit/update pages" do
      before(:each) do
        @user = Factory(:user)
      end

      describe "for non-signed user" do
        it "Should deny access to the edit page" do
          get :edit, :id => @user
          response.should redirect_to(signin_path)
        end
        it "Should deny access to the update page" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end
      end

      describe "for signed in user" do
        before(:each) do
          wrong_user = Factory(:user, :email => 'wrong_email@example.com')
          test_sign_in(wrong_user)
        end
        it "Should deny access to edit page for wrong user" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
        end
        it "Should deny access to update page for wrong user" do
          get :edit, :id => @user, :user => {}
          response.should redirect_to(root_path)
        end
      end


  end

  describe "Admin attribute" do
    before(:each) do
       @attr = { :name => 'New name', :email => 'new@example.com', :password => 'bazbar', :password_confirmation => 'bazbar' }
      @user = User.create!(@attr)
    end

    it "Should have an admin attribute" do
      @user.should respond_to(:admin)
    end

    it "Should not be admin by default" do
      @user.should_not be_admin
    end

    it "Should be able to toggle to admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "'delete' destroy" do
    before(:each) do
      @user = Factory(:user)
    end
    describe "for non-signed in user" do
      it "Should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    describe "for signed in non-admin user" do
      before(:each) do
        test_sign_in(@user)
      end
      it "Should protect the page" do
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end
    describe "for signed in admin user" do
      before(:each) do
        admin_user = Factory(:user, :email => 'anotherexample@example.com', :admin => true)
        test_sign_in(admin_user)
      end

      it "Should decrease the count of the user" do
        lambda do 
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1) 
      end

      it "Should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end

  describe "follow page" do
    describe "When user is not signed in" do
      it "Should deny access to the following page" do
        get :following, :id => 1
        response.should redirect_to(signin_path)
      end
      it "Should deny access to the following page" do
        get :followers, :id => 1
        response.should redirect_to(signin_path)
      end
    end
  
    describe "When the user is signed in" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @other_user = Factory(:user, :email => Factory.next(:email))
        @user.follow!(@other_user)
      end

      it "Should show user following" do
        get :following, :id => @user
        response.should have_selector('a', :href => user_path(@other_user), :content => @other_user.name )
      end

      it "Should show user followers" do
         get :followers, :id => @other_user
        response.should have_selector('a', :href => user_path(@user), :content => @user.name )
      end
    end
  end
end

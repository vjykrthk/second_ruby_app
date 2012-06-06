require 'spec_helper'

describe "LayoutLinks" do
  it "Should have a contact page at '/contact'" do
  	get '/contact'
  	response.should have_selector('title', :content => "Contact")
  end
  
  it "Should have a help page at '/help'" do
  	get '/help'
  	response.should have_selector('title', :content => 'Help')
  end

  it "Should have a about page at '/about'" do
  	get '/about'
  	response.should have_selector('title', :content => 'About')
  end

  it "Should have a home page at '/'" do
  	get '/'
  	response.should have_selector('title', :content => 'Home')
  end

  it "Should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => 'Sign Up')
  end

  it "Should have right links on the pages layout" do
    visit root_path
    response.should have_selector('title', :content => 'Home')
    click_link "About"
    response.should have_selector('title', :content => 'About')
    click_link "Help"
    response.should have_selector('title', :content => 'Help')
    click_link "Contact"
    response.should have_selector('title', :content => 'Contact')
    # click_link "Sign up now"
    # response.should have_selector('title', :content => 'Sign Up')
    response.should have_selector('a[href="/"]>img')
  end

  describe "When user is signed out" do
    it "Should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => signin_path, :content => "Signin")
    end
  end

  describe "When user is signed in" do
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end
    it "Should have a sign out link" do
      visit root_path
      response.should have_selector("a", :href => signout_path, :content => "Signout")
    end
    it "Should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user), :content => "Profile")
    end
  end  
end

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
    click_link "Sign up now"
    response.should have_selector('title', :content => 'Sign Up')
    response.should have_selector('a[href="/"]>img')
  end  
end

require 'spec_helper'

describe StaticPagesController do
  render_views

  before(:each) do
    @Base_title = "Ruby on rails first app"
  end

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector('title', 
                                    :content => "#{@Base_title} | Home")
    end
  end

  describe "GET 'help'" do
    it "returns http success" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title", 
                                    :content => "#{@Base_title} | Help")
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title", 
                                    :content => "#{@Base_title} | About")
    end
  end

end

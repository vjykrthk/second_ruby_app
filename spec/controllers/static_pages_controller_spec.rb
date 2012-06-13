require 'spec_helper'

describe StaticPagesController do
  render_views

  before(:each) do
    @Base_title = "Ruby on rails first app"
  end

  describe "GET 'home'" do
    describe "When not signed in" do
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
    describe "When signed in" do
      before(:each) do
        @user = Factory(:user)
        other_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(@user)
        other_user.follow!(@user)
      end

      it "Should have right following and followers count" do
        get 'home'
        response.should have_selector('a', :href => following_user_path(@user), :content => '0 following' )
        response.should have_selector('a', :href => followers_user_path(@user), :content => '1 follower' )
      end
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

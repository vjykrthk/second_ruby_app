require 'spec_helper'

# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

describe Micropost do
  before(:each) do
  	@user = Factory(:user)
  	@attr = { :content => "fooobar" }
  end

  it "Should create new instance given right attributes" do
  	@user.microposts.create!(@attr)
  end

  describe "user associations" do
  	before(:each) do
  		@microposts = @user.microposts.create!(@attr)
  	end

  	it "Should have user attribute" do
  		@microposts.should respond_to(:user)
  	end

  	it "Should have right associated user" do
  		@microposts.user_id.should == @user.id
  		@microposts.user.should == @user
  	end
  end

  describe "validation" do
  	it "Should require a user id" do
  		Micropost.new(@attr).should_not be_valid
  	end

  	it "Should not have empty content" do
  		@user.microposts.build(:content => "").should_not be_valid
  	end

  	it "Should not have content more 140 characters" do
  		@user.microposts.build(:content => "a"*141).should_not be_valid
  	end
  end

  describe "from users followed by" do
    before(:each) do
      other_user = Factory(:user, :email => Factory.next(:email))
      third_user = Factory(:user, :email => Factory.next(:email))

      @user_post = @user.microposts.create!(:content => "foo")
      @other_user_post = other_user.microposts.create!(:content => "bar")
      @third_user_post = third_user.microposts.create!(:content => "baz")
      @user.follow!(other_user)
    end

    it "Should have from_users_followed_by method" do
      Micropost.should respond_to(:from_users_followed_by)
    end

    it "Should include microposts of users followed" do
      Micropost.from_users_followed_by(@user).should include(@other_user_post)
    end

    it "Should include microposts of the user" do
      Micropost.from_users_followed_by(@user).should include(@user_post)
    end

    it "Should not include microposts of users not followed" do
      Micropost.from_users_followed_by(@user).should_not include(@third_user_post)
    end
  end
end
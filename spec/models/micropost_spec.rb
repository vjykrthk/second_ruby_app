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
end
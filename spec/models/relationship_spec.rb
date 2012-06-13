# == Schema Information
#
# Table name: relationships
#
#  id          :integer         not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Relationship do
  before(:each) do
  	@follower = Factory(:user)
  	@followed = Factory(:user, :email => Factory.next(:email))
  	@relationships = @follower.relationships.build(:followed_id => @followed.id)
  end

  it "Should create a new relationship given right attributes" do
  	@relationships.save!
  end

  describe "follow method" do
  	before(:each) do
  		@relationships.save
  	end

  	it "Should have a follower attribute" do
  		@relationships.should respond_to(:follower)
  	end

  	it "Should have the right follower" do
  		@relationships.follower.should == @follower
  	end

  	it "Should have a followed attribute" do
  		@relationships.should respond_to(:followed)
  	end

  	it "Should have the right followed user" do
  		@relationships.followed.should == @followed
  	end
  end

  describe "validations" do
  	it "Should require follower id" do
  		@relationships.follower_id = nil
  		@relationships.should_not be_valid
  	end
  	it "Should require followed id" do
  		@relationships.followed_id = nil
  		@relationships.should_not be_valid
  	end
  end
end
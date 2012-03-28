# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
	before(:each) do
		@attr = { 	:name => 'vijay karthik', 
					:email => 'vjykrthk@gmail.com', 
					:password => 'foobar',
					:password_confirmation => 'foobar'
				}
	end

	it "Should create a new user given valid attributes" do
		User.create!(@attr)
	end

	it "Should reject users with blank name field" do
	  no_name_user = User.new(@attr.merge(:name => ''))
	  no_name_user.should_not be_valid
	end

	it "Should reject names that are too long" do
		too_long_name = "a" * 51
		long_user = User.new(@attr.merge(:name => too_long_name))
		long_user.should_not be_valid
	end

	it "Should accept valid email addresses" do
		addresses = %w[hkdd@gg.com ht.ddd.@fff.co.in th@co.in]
		addresses.each do |address|
			valid_email_user = User.new(@attr.merge(:email => address))
			valid_email_user.should be_valid
		end
	end

	it "Should reject invalid email addresses" do
		addresses = %w[hkdd@gg ht,ddd.@fff.co.in th@co.in.]
		addresses.each do |address|
			invalid_email_user = User.new(@attr.merge(:email => address))
			invalid_email_user.should_not be_valid
		end
	end

	it "Should reject duplicate email addresses" do
		User.create!(@attr)
		duplicate_email_user = User.new(@attr)
		duplicate_email_user.should_not be_valid
	end

	it "Should reject duplicate emails case-insentive" do
		upcased_email = @attr[:email].upcase
		User.create!(@attr)
		duplicate_upcase_email_user = User.new(@attr.merge(:email => upcased_email))
		duplicate_upcase_email_user.should_not be_valid
	end

	describe "Password validation" do
		it "Should require a password" do
			without_password = User.new(@attr.merge(:password => "", :password_confirmation => ""))
			without_password.should_not be_valid
		end

		it "Should have same password and confirm_password" do
			without_matching_password = User.new(@attr.merge(:password_confirmation => "invalid"))
			without_matching_password.should_not be_valid
		end

		it "Should have minimum length" do
			short = "a" * 5
			minimum_length_password = User.new(@attr.merge(:password => short))
			minimum_length_password.should_not be_valid
		end

		it "Should not exceed maximum length" do
			long = "a" * 41
			maximum_length_password = User.new(@attr.merge(:password => long))
			maximum_length_password.should_not be_valid
		end
	end

	describe "Password encryption" do \
		before(:each) do
			@user = User.create!(@attr)
		end 

		it "Should have encrypted password stored in database" do
			@user.should respond_to(:encrypted_password)
		end

		it "Should not be blank" do
			@user.encrypted_password.should_not be_blank
		end

		describe "has password? method" do
			it "Should be true if the password match" do
				@user.has_password?(@attr[:password]).should be_true
			end

			it "Should be false if the password don't match" do
				@user.has_password?("invalid").should_not be_true
			end
		end

		describe "User authentication" do
			it "Should return nil on email/password mismatch" do
				User.authenticate(@attr[:email], "wrong password").should be_nil
			end

			it "Should return nil on wrong username" do
				User.authenticate("foobar@gmail.com", @attr[:password]).should be_nil
			end

			it "Should return user on email/password match" do
				User.authenticate(@attr[:email], @attr[:password]).should == @user
			end	
		end
	end

end

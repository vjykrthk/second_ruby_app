# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#
require "digest"
class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation
	valid_regex = /\A[\w+.\-]+@[a-z\d.\-]+\.[a-z]+\z/i
	validates :name, 	:presence => true,
						:length => {:maximum => 50}

	validates :email,	:presence => true,
						:format => {:with => valid_regex},
						:uniqueness => {:case_sensitive => false}

	validates :password, 	:presence => true,
							:confirmation => true,
							:length => {:within => 6..40}
							

	before_save :encrypt_password
	has_many :microposts, :dependent => :destroy
	has_many :reverse_relationships, :foreign_key => "followed_id", :class_name => 'Relationship'
	has_many :followers, :through => :reverse_relationships, :source => :follower 
	has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
	has_many :following, :through => :relationships, :source => :followed

	def has_password?(password)
		self.encrypted_password == encrypt(password)
	end

	def self.authenticate(email, password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(password)
	end

	def self.authenticate_with_salt(id, salt)
		user = find_by_id(id)
		(user && user.salt == salt) ? user : nil
	end

	def feed
		Micropost.from_users_followed_by(self)
	end

	def follow!(followed)
		relationships.create(:followed_id => followed.id)
	end

	def unfollow!(followed)
		relationships.find_by_followed_id(followed).destroy
	end

	def following?(followed)
		relationships.find_by_followed_id(followed)
	end

	private
	def encrypt_password
		self.salt = make_salt unless has_password?(password)
		self.encrypted_password = encrypt(password)
	end

	def make_salt
		secure_hash("#{Time.now.utc}--#{password}")
	end

	def encrypt(string)
		secure_hash("#{salt}--#{string}")
	end

	def secure_hash(password)
		Digest::SHA2.hexdigest(password) 
	end
end




# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#


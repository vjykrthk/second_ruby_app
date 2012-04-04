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

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


class Micropost < ActiveRecord::Base
	attr_accessible :content
	validates :user_id, :presence => true
	validates :content, :presence => true, :length => {:maximum => 140}
	belongs_to :user

	default_scope :order => 'microposts.created_at DESC'
	scope :from_users_followed_by, lambda { |user| followed_users(user) }

	private

	def self.followed_users(user)
		followed_id = %(SELECT followed_id FROM relationships WHERE follower_id = :user_id)
		where("user_id IN (#{followed_id}) OR user_id = :user_id", { :user_id => user })
	end
end
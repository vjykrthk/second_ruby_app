namespace :db do
	desc "Populate the database"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		make_users
		make_microposts
		make_relationships
	end	
end

def make_users
	user = User.create!(:name => 'Example user', :email => 'exampleuser@example.com', :password => 'foobar', :password_confirmation => 'foobar')
	user.toggle!(:admin)
	99.times do |n|
		name = Faker::Name.name
		email = "example-#{n+1}@railstutorial.org"
		password = 'password'
		User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
	end	
end

def make_microposts
	50.times do
		User.all(:limit => 6).each do |user|
			user.microposts.create!(:content => Faker::Lorem.sentence(10))
		end
	end	
end

def make_relationships
	users = User.all
	user = User.first
	following = users[1..50]
	followers = users[3..50]
	following.each do |followed|
		user.follow!(followed)
	end

	followers.each do |follower|
		follower.follow!(user)
	end
end
namespace :db do
	desc "Populate the database"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		user = User.create!(:name => 'Example user', :email => 'exampleuser@example.com', :password => 'foobar', :password_confirmation => 'foobar')
		user.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = 'password'
			User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
		end
	end	
end
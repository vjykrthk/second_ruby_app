Factory.define :user do |user|
	user.name "vijay karthik"
	user.email "vjykrthk@gml.com"
	user.password "karthik"
	user.password_confirmation "karthik"
end

Factory.sequence :name do |n|
	"Person-#{n}"
end

Factory.sequence :email do |n|
	"person-#{n}@exampleuser.com"
end
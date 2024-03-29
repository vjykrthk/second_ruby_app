require 'spec_helper'

describe "FriendlyForwadings" do
  it "Should signin to the request page after signin" do
  	user = Factory(:user)
  	visit edit_user_path(user)
  	fill_in :email, :with => user.email
  	fill_in :password, :with => user.password
  	click_button
  	response.should render_template('users/edit')
  end
end

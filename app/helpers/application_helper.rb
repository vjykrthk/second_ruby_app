module ApplicationHelper
	def title
		base_title = "Ruby on rails first app"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end

	def logo
		image_tag("second_app.jpeg", :alt=>"Second app", :class=>"round" )
	end
end

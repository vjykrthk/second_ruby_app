module ApplicationHelper
	def title
		base_title = "Ruby on rails first app"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end
end

module NavigationHelpers
	def path_to(page_name)
		case page_name
		when ResourceExpr
			template_for($1, $2)
		when ActionOnResourceExpr
			action_path_for($1, $2, Member.to_pc($3))
		when TheSomethingPageExpr
			case $1
			when /home/
				root_path
			when /booking/
				book_path
			when /next concert/
				next_concerts_path
			when /upcoming concerts/
			  upcoming_concerts_path
			when /private member list/
				private_roster_path
			when /create-new-member/
				new_member_path
			when /login/
				login_path
			else
				request = recognized_request_for(path, :get)
				unless request.nil?
					page_name
				else
					raise "Can't find mapping from \"#{page_name}\" to a path."
				end
			end
		when QuotedPathExpr
			$1
		when SomeonesHomePageExpr
			someone = $1
			unless (someone =~ /nonexistant/)
				member_path(Member.find_by_name(someone))
			else
				Member.find_by_name('Nobody Special').destroy if Member.exists?(:name => 'Nobody Special')
				'members/nobody_special'
			end
		else
			page_name
		end
	end

	def template_called(page_name)
		case page_name
		when ResourceExpr
			template_for($1, $2)
		when ActionOnResourceExpr
			action_template_for($1, $2, $3)
		when TheSomethingPageExpr
			case $1
			when /home/
				"index"
			when /booking/
				'book/index'
			when /next concert/
				'concerts/next'
			when /private member list/
				"private/rosters/show"
			when /create-new-member/
				"members/new"
			when /login/
				"sessions/new"
			else
				page_name
			end
		when SomeonesHomePageExpr
			'members/show'
		when SomeonesPublicPageExpr
			'members/show'
		when QuotedPathExpr
			$1
		else
			page_name
		end
	end

	private
		ResourceExpr = /the (index|show|new|create|edit|update|destroy) (\w+) (page|form)/i
		ActionOnResourceExpr = /(edit|create|show|destroy|update) (\w+) (.*)/
		TheSomethingPageExpr = /the '?(.*[^'])'? (page|form)/i
		SomeonesHomePageExpr = /(.*)'s home page/i
		SomeonesPublicPageExpr = /(.*)'s public page/
		QuotedPathExpr = /^'([^']*)'$/i

		def action_path_for(action, resource, id)
			"#{resource.pluralize.gsub(" ", "_")}/#{id}/#{action}"
		end	

		# turns 'new', 'road bikes' into 'road_bikes/new'
		# note that it's "action resource"
		def template_for(action, resource)
			"#{resource.gsub(" ","_")}/#{action}"
		end
		
		def action_template_for(action, resource, id)
			"#{resource.pluralize.gsub(" ", "_")}/#{action}"
		end
end

World(NavigationHelpers)

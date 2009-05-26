require 'uri'

module GenerateAStablePathComponentMatcher
	class GenerateAStablePathComponent
		def matches?(target)
			@target = target
			pc = target.to_pc
			@path_does_not_require_parsing = (pc == URI.parse(pc).to_s)
			@path_is_recognizable = (Member.find_by_path_component(pc) == @target)
			@path_does_not_require_parsing and @path_is_recognizable
		end
		
		def failure_message_for_should
			message = "The Member #{@target} failed to generate a clean path component.\n"
			
			unless @path_does_not_require_parsing
				message << "\t#{@target.to_pc}\nwas further parsed to\n\t#{URI.parse(@target.to_pc)}."
			end
			
			unless @path_is_recognizable
				message << "\nAdditionally:\n" unless @path_does_not_require_parsing
				message << "\t#{@target.to_pc}\nfailed to re-generate the source model."
			end
		end
		
		def failure_message_for_should_not
			"Expected that '#{@target.to_pc}' should be an invalid URI path component, but it did not require further parsing."
		end
		
		def description
			'generate a stable path component'
		end
	end
	
	def generate_a_stable_path_component
		GenerateAStablePathComponent.new
	end
end
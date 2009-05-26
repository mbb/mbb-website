ENV["RAILS_ENV"] = "test"
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'environment'))
require 'spec/autorun'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

	# Require all of our custom matchers
	(Dir.entries(File.join(File.dirname(__FILE__), 'matchers')) - ['.', '..']).each do |filename|
		if filename =~ /\.rb\Z/
			require File.expand_path(File.join(File.dirname(__FILE__), 'matchers', filename))
			config.include "#{filename[/.+(?=\.rb\Z)/].camelize}Matcher".constantize
		end
	end
end

# Extend be_valid with better error messages.
module Spec
	module Rails
		module Matchers
			class BeValid	#:nodoc:

				def matches?(model)
					@model = model
					@model.valid?
				end

				def failure_message_for_should
					"#{@model.class} expected to be valid but had errors:\n	#{@model.errors.full_messages.join("\n	")}"
				end

				def failure_message_for_should_not
					"#{@model.class} expected to have errors, but it did not"
				end

				def description
					"be valid"
				end

			end

			def be_valid
				BeValid.new
			end
		end
	end
end

# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require 'cucumber/rails/world'
require 'cucumber/formatters/unicode' # Comment out this line if you don't want Cucumber Unicode support
Cucumber::Rails.use_transactional_fixtures

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

module Webrat
	class MechanizeSession
		def mechanize
			@mechanize ||= WWW::Mechanize.new
		end
	end
	
	class Form
		protected
			#
			# Redefines Webrat::Form#form_method to use the *actual* request method employed by
			# the Rails controller.
			#
			# When Rails sets up a form for the update action, it employs the HTTP PUT method.
			# Unfortunately, for most browsers, if you write, "<form ... method="put">", it will
			# assume you're an idiot and actually execute a POST request.
			#
			# Rails' solution to this problem is to include a hidden field (input[name="_method"])
			# whose value is the actual request method to recognize on the controller side if this
			# method is PUT or DELETE. The existing Webrat form submission method
			# (Webrat::Form#submit) does not take this into account, hence this monkey-patch.
			def form_method
				special_method = Webrat::XML.css_search(@element, 'input[name="_method"]').first
				unless special_method.nil?
					special_method['value']
				else
					Webrat::XML.attribute(@element, "method").blank? ? :get : Webrat::XML.attribute(@element, "method").downcase
				end
			end
	end
end

Fixtures.create_fixtures("spec/fixtures", "concerts")
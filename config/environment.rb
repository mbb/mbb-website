# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
	config.time_zone = 'Central Time (US & Canada)'
	config.i18n.default_locale = :en
	
	config.gem 'paperclip', :version => '>= 2.3.1.1'
	config.gem 'authlogic', :version => '>= 2.1.3'
	config.gem 'friendly_id', :version => '~> 2.2.5'
	config.gem 'RedCloth', :version => '>= 4.0'
	
	config.active_record.observers = :member_observer
end

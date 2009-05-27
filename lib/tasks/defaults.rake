namespace :db do
	namespace :defaults do
		desc 'Destroys all existing sections and sets them to the default brass band sections.'
		task :load => :environment do
			require 'active_record/fixtures'
			Fixtures.create_fixtures('spec/fixtures', 'sections')
			Fixtures.create_fixtures('spec/fixtures', 'roles')
		end
	end
end

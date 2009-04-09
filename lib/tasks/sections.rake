namespace :sections do
	desc "Destroys all existing sections and sets them to the default brass band sections."
	task :generate => :environment do
		require 'active_record/fixtures'
		Fixtures.create_fixtures("spec/fixtures", "sections")
	end
end

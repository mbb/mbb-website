namespace :sections do
	desc "Destroys all existing sections and sets them to the default brass band sections."
	task :generate => :environment do
		instruments = [
			'Soprano Cornet',
			'Cornet',
			'Flugelhorn',
			'Alto Horn',
			'Trombone',
			'Bass Trombone',
			'Euphonium',
			'Baritone',
			'Eb Bass',
			'Bb Bass',
			'Percussion'
		]

		Section.destroy_all
		instruments.each do |instrument|
			Section.create!(:instrument => instrument)
		end
	end
end

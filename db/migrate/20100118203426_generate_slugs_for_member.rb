class GenerateSlugsForMember < ActiveRecord::Migration
	def self.up
		ENV['MODEL'] = 'Member'
		Rake::Task['friendly_id:make_slugs'].invoke
	end
	
	def self.down
		# Nothing
	end
end

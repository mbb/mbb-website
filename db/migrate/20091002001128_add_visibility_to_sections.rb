class AddVisibilityToSections < ActiveRecord::Migration
	def self.up
		add_column :sections, :visible, :boolean, :default => true
	end
	
	def self.down
		remove_column :members, :visible
	end
end

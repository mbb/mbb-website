class MakeSectionHierarchical < ActiveRecord::Migration
	def self.up
		add_column :sections, :parent_id, :integer, :default => nil
	end

	def self.down
		remove_column :sections, :parent_id
	end
end

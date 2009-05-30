class RemoveSectionHierarchy < ActiveRecord::Migration
	def self.up
		remove_column :sections, :parent_id
	end

	def self.down
		add_column :sections, :parent_id, :integer
	end
end

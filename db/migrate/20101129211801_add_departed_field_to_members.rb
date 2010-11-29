class AddDepartedFieldToMembers < ActiveRecord::Migration
	def self.up
		add_column :members, :departed, :boolean, :default => false
	end
	
	def self.down
		remove_column :members, :departed
	end
end

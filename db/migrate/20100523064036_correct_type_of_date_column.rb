class CorrectTypeOfDateColumn < ActiveRecord::Migration
	def self.up
		change_column :concerts, :date, :date
	end
	
	def self.down
		change_column :concerts, :date, :datetime
	end
end

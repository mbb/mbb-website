class ChangeSectionInstrumentToName < ActiveRecord::Migration
	def self.up
		rename_column :sections, :instrument, :name
	end
	
	def self.down
		rename_column :sections, :name, :instrument
	end
end

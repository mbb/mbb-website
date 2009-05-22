class SeparateDateAndTime < ActiveRecord::Migration
	def self.up
		add_column :concerts, :time, :time
		rename_column :concerts, :date_and_time, :date
	end

	def self.down
		rename_column :concerts, :date, :date_and_time
		remove_column :concerts, :time
	end
end

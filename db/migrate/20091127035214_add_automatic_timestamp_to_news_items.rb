class AddAutomaticTimestampToNewsItems < ActiveRecord::Migration
	def self.up
		rename_column :news_items, :date, :created_at
	end
	
	def self.down
		rename_column :news_items, :created_at, :date
	end
end

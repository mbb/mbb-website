class AddConcertsToDatabase < ActiveRecord::Migration
	def self.up
		create_table :concerts, :force => true do |t|
			t.string :title
			t.datetime :date_and_time
			t.string :location
			t.text :description
			t.text :google_map_url
		end
	end
	
	def self.down
		drop_table :concerts
	end
end

class CreateStories < ActiveRecord::Migration
	def self.up
		create_table :stories do |t|
			t.string :title
			t.date :date
			t.text :body
		end
	end

	def self.down
		drop_table :stories
	end
end

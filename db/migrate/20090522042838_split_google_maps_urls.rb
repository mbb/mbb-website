class SplitGoogleMapsUrls < ActiveRecord::Migration
	def self.up
		remove_column :concerts, :google_map_url
		add_column :concerts, :google_map_embed_url, :string
		add_column :concerts, :google_map_link_url, :string
	end

	def self.down
		remove_column :concerts, :google_map_link_url
		remove_column :concerts, :google_map_embed_url
		add_column :concerts, :google_map_url, :text
	end
end

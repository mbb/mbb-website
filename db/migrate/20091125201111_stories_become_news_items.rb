class StoriesBecomeNewsItems < ActiveRecord::Migration
  def self.up
    rename_table :stories, :news_items
  end

  def self.down
    rename_table :news_items, :stories
  end
end

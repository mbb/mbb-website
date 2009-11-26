class AddPrivacyFlagToNewsItems < ActiveRecord::Migration
  def self.up
    add_column :news_items, :is_private, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :news_items, :is_private
  end
end

class ChangeNewsItemsToIncludeTime < ActiveRecord::Migration
  def self.up
	  change_column :news_items, :created_at, :datetime
  end

  def self.down
		change_column :news_items, :created_at, :date
  end
end

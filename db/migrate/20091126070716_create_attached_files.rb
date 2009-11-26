class CreateAttachedFiles < ActiveRecord::Migration
  def self.up
    create_table :attached_files do |t|
			t.string :data_file_name
			t.string :data_content_type
			t.integer :data_file_size
			t.references :news_item
      t.timestamps
    end
  end

  def self.down
    drop_table :attached_files
  end
end

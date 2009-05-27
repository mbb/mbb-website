class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
			t.string :first_name
			t.string :middle_names
			t.string :last_name
			t.text :biography
			t.references :section
			
      t.timestamp :created_at
    end
  end

  def self.down
    drop_table :members
  end
end

class AddLoginFieldsToMembers < ActiveRecord::Migration
	def self.up
		add_column :members, :email, :string, :limit => 100, :default => '', :null => false
		add_column :members, :crypted_password, :string, :limit => 100
		add_column :members, :salt, :string, :limit => 40
		add_column :members, :remember_token, :string, :limit => 40
		add_column :members, :remember_token_expires_at, :datetime
		add_index :members, :email, :unique => true
	end
	
	def self.down
		remove_column :members, :remember_token_expires_at
		remove_column :members, :remember_token
		remove_column :members, :salt
		remove_column :members, :crypted_password
		remove_column :members, :email
	end
end

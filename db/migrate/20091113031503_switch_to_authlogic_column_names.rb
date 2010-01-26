class SwitchToAuthlogicColumnNames < ActiveRecord::Migration
	def self.up
		change_column :members, :crypted_password,	 :string,	:limit => 128, :null => false, :default => ''
		change_column :members, :salt,							 :string,	:limit => 128, :null => false, :default => ''
		
		add_column		:members, :persistence_token,	:string
		add_column		:members, :perishable_token,	 :string
		add_column		:members, :failed_login_count, :integer, :null => false, :default => 0
		add_column		:members, :last_login_at,			:datetime
	end
	
	def self.down
		remove_column :members, :last_login_at
		remove_column :members, :failed_login_count
		remove_column :table_name, :persistence_token
		remove_column :members, :perishable_token
		
		change_column :members, :salt,						 :string, :limit => 40
		change_column :members, :crypted_password, :string, :limit => 100
	end
end

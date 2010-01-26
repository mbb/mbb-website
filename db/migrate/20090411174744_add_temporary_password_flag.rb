class AddTemporaryPasswordFlag < ActiveRecord::Migration
	def self.up
		add_column :members, :password_is_temporary, :boolean, :default => false
	end
	
	def self.down
		remove_column :members, :password_is_temporary
	end
end

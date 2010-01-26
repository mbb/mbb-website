class AddPhoneNumberToMember < ActiveRecord::Migration
	def self.up
		add_column :members, :phone_number, :string, :length => 10
	end
	
	def self.down
		remove_column :members, :phone_number
	end
end

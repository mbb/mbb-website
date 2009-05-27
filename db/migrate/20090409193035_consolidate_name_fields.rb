class ConsolidateNameFields < ActiveRecord::Migration
	def self.up
		add_column :members, :name, :string
		
		say_with_time 'Convert members\' piece-wise names to full names...' do
			Member.all.each do |member|
				new_name = "FOO"
				unless member.attributes['middle_names'].nil?
					new_name = "#{member.attributes['first_name']} #{member.attributes['middle_names']} #{member.attributes['last_name']}"
				else
					new_name = "#{member.attributes['first_name']} #{member.attributes['last_name']}"
				end
				member.attributes = {:name => new_name}
				member.save!
			end
		end
		
    remove_column :members, :first_name
    remove_column :members, :middle_names
		remove_column :members, :last_name
	end

	def self.down
    add_column :members, :first_name, :string
		add_column :members, :middle_names, :string
		add_column :members, :last_name, :string
		
		say_with_time 'Convert members\' full names to piece-wise names...' do
			Member.all.each do |member|
				name = member.attributes['name'].match FullName
				member.attributes = {:first_name => name[1], :middle_names => name[2], :last_name => name[3]}
				member.save!
			end
		end
		
		remove_column :members, :name
	end
	
	private
		FirstName = /([\w\.]+)/
		MiddleNames = /\s([\w\s\.]+)/
		LastName = /\s([\w\.]+)/
		FullName = /#{FirstName} #{MiddleNames}? #{LastName}/x
end

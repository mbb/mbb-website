# Previously to this migration, the number of "roles" in the website were unlimited.
# You could have all sorts of roles. Very flexible, and unfortunately very useless.
# Moreover, this is difficult to represent to the user, who has to understand how
# to assign /n/ roles to members instead of something simpler.
#
# The new, simpler role system will have just two classes: privileged and
# unprivileged. The idea is that privileged members can edit anything. Unprivileged members
# can only edit their own profile. More fine-grain control will be controlled
# by people talking to each other.
class CreateNewRoleStructure < ActiveRecord::Migration
	def self.up
		add_column :members, :privileged, :boolean, :default => false
		
		# Convert the "roles" table to match the new privileged column.
		say_with_time 'Noting privileged members from Roles table...' do
			Member.reset_column_information   # Otherwise, it won't generate SQL for the privileged column.
			Member.all.each do |m|
				unless m.roles.count == 0
					m.privileged = true
					m.save!
					say "#{m} is privileged.", true
				end
			end
		end
		
		drop_table :roles
		drop_table :members_roles
	end
	
	def self.down
		create_table "roles" do |t|
			t.string "name"
		end
		Rake::Task['db:defaults:load'].invoke   # This creates the default set of roles.
		
		create_table "members_roles", :id => false, :force => true do |t|
			t.integer "role_id"
			t.integer "member_id"
		end
		
		# For simplicity, "privileged" now means you have _all_ available roles.
		say_with_time 'Giving all roles to privileged members...' do
			Member.all.each do |m|
				if m.privileged?
					m.roles = Role.all
					m.save!
					say "#{m} now meets: #{Role.all}", true
				end
			end
		end
		remove_column :members, :privileged
		
		add_index "members_roles", ["member_id"], :name => "index_members_roles_on_member_id"
		add_index "members_roles", ["role_id"], :name => "index_members_roles_on_role_id"
	end
end

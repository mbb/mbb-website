RE_member			= %r{(?:(?:the )? *(\w+) *)}
MemberType = %r{(?: *(\w+)? *)}

#
# Setting
#

Given "an anonymous member" do
	log_out!
end

Given "an? $role member with $attributes" do |role, attributes|
	create_member! role, attributes.to_hash_from_story
end

Given "an? $role member named '$login'" do |role, login|
	create_member! role, named_member(login)
end

Given "an? $role member logged in as '$name'" do |role, name|
	member = named_member(name)
	create_member! role, member
	log_in_member! member
	response.should_not render_template('sessions/new')
end

Given "'$actor' is logged in" do
	log_in_member! @member_params
	response.should_not render_template('sessions/new')
end

Given "there is no $role member named '$name'" do |_, name|
	@member = member.find_by_name(name)
	@member.destroy! if @member
	@member.should be_nil
end

#
# Actions
#
When "$actor logs out" do
	log_out
end

When "$actor registers an account for the preloaded '$login'" do |_, login|
	member = named_member(login)
	member.delete(:password)
	register_member member
end

When "$actor registers an account with $attributes" do |_, attributes|
	member_attrs = attributes.to_hash_from_story
	register_member member_attrs
end


When "$actor logs in with $attributes" do |_, attributes|
	log_in_member attributes.to_hash_from_story
end

#
# Result
#
Then "$actor should be invited to sign in" do |_|
	response.should render_template('/sessions/new')
end

Then "$actor should not be logged in" do |_|
	controller.logged_in?.should_not be_true
end

Then "$actor should be logged in" do |name|
	controller.logged_in?.should be_true
	controller.current_member.name.should == name
end

def named_member name
	member_params = {
		'Admin Funkle'	 => {'name' => 'Admin Funkle',	'password' => '1234admin',  'email' => 'admin@example.com',			 'section' => 'Euphonium'},
		'Oona Funkle'		 => {'name' => 'Oona Funkle',	  'password' => '1234oona',   'email' => 'unactivated@example.com', 'section' => 'Euphonium'},
		'Reggie Funkle'	 => {'name' => 'Reggie Funkle', 'password' => '1234reggie', 'email' => 'registered@example.com' , 'section' => 'Euphonium'},
		}
	member_params[name]
end

#
# member account actions.
#
# The ! methods are 'just get the job done'.	It's true, they do some testing of
# their own -- thus un-DRY'ing tests that do and should live in the member account
# stories -- but the repetition is ultimately important so that a faulty test setup
# fails early.
#

def log_out
	delete '/session'
end

def log_out!
	log_out
	response.should redirect_to('/')
	follow_redirect!
end

def create_role(name)
	Role.create!(:name => name)
end

def create_member(member_params={})
	clean_member_params!(member_params)
	Member.create!(member_params)
end

def create_member!(role_name, member_params)
	role = create_role(role_name)
	create_member member_params.merge(:roles => [role])
end

def clean_member_params!(member_params)
	member_params['password_confirmation'] ||= member_params['password']
	
	Fixtures.create_fixtures('spec/fixtures', 'sections')
	section = member_params['section']
	
	case section.class.name
	when 'Integer':
		member_params['section_id'] = section
		member_params['section'] = Section.find(section)
	when 'String':
		member_params['section'] = Section.find_by_instrument(section)
		member_params['section_id'] = member_params['section'].id
	when 'Section':
		member_params['section_id'] = section.id
	end

	member_params
end

def register_member(member_params)
	clean_member_params!(member_params)
	visit '/private/members/new'
	response.should render_template('private/members/new')
	fill_in 'member_name', :with => member_params['name']
	fill_in 'member_email', :with => member_params['email']
	select member_params['section'].instrument, :from => 'member_section_id'
	click_button 'Create Member'
end

def log_in_member member_params=nil
	@member_params ||= member_params
	member_params	||= @member_params
	visit login_path
	fill_in 'name', :with => member_params['name']
	fill_in 'password', :with => member_params['password']
	click_button 'Log in'
	@member = controller.current_member
end

def log_in_member! member_params
	member_params.merge('password' => 'madisonbrass', 'password_confirmation' => 'madisonbrass') if member_params['password'].nil?
	log_in_member member_params
end

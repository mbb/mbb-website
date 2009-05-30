#
# Setting
#

Given "an anonymous $whoever" do |_|
	log_out!
end

Given "an? $role member with $attributes" do |role, attributes|
	create_member! role, attributes.to_hash_from_story
end

Given "an? $role member named '$name'" do |role, name|
	create_member! role, named_member(name)
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

Given "we memorize $name's $attributes" do |name, attrs|
	member = Member.find_by_name(name)
	member.should_not be_nil
	memorize_member_attributes(member, attrs)
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

Then '$actor should have the default password' do |member_name|
	member = Member.find_by_name(member_name)
	member.should_not be_nil
	member.password_is_temporary.should be(true)
	Member.authenticate(member.email, Member.default_password).should_not be_nil
end

Then '$name\'s $attribute should change' do |name, attribute|
	member = Member.find_by_name(name)
	member.should_not be_nil
	member.should respond_to(attribute)
	
	new_value = member.send(attribute)
	old_value = recall_member_attribute(member, attribute)
	old_value.should_not eql(new_value)
end

Then '$name\'s $attribute should not change' do |name, attribute|
	member = Member.find_by_name(name)
	member.should_not be_nil
	member.should respond_to(attribute)
	
	new_value = (member.send(attribute).nil?) ? '' : member.send(attribute)
	old_value = recall_member_attribute(member, attribute)
	old_value.should eql(new_value)
end

def named_member name
	member_params = {
		'Admin Funkle' => {'name' => 'Admin Funkle',
		                   'password' => '1234admin',
		                   'email' => 'admin@example.com',
		                   'section' => 'Euphonium'},
		'Oona Funkle' => {'name' => 'Oona Funkle',
		                  'password' => '1234oona',
		                  'email' => 'unactivated@example.com',
		                  'section' => 'Euphonium',
		                  'photo_file_name' => "features/support/new_picture.jpg",
		                  'photo_file_size' => 20173,
		                  'photo_content_type' => 'image/jpeg'},
		'Reggie Funkle' => {'name' => 'Reggie Funkle',
		                    'password' => '1234reggie',
		                    'email' => 'registered@example.com' ,
		                    'section' => 'Euphonium'},
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
	unless role_name == 'regular'
		role = create_role(role_name)
		create_member member_params.merge(:roles => [role])
	else
		create_member member_params
	end
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
		member_params['section'] = Section.find_by_name(section)
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
	select member_params['section'].name, :from => 'member_section_id'
	click_button 'Create Member'
end

def log_in_member member_params=nil
	@member_params ||= member_params
	member_params	||= @member_params
	visit login_path
	fill_in 'email', :with => member_params['email']
	fill_in 'password', :with => member_params['password']
	click_button 'Log in'
	@member = controller.current_member
end

def log_in_member! member_params
	member_params.merge('password' => 'madisonbrass', 'password_confirmation' => 'madisonbrass') if member_params['password'].nil?
	log_in_member member_params
end

def memorize_member_attributes(member, attrs)
	varname = "@#{member.to_pc}"
	if instance_variable_get(varname).nil?
		instance_variable_set(varname, Hash.new)
	end
	
	attrs.to_array_from_story.each do |attr|
		member.should respond_to(attr)
		var = instance_variable_get(varname)
		var["#{attr}"] = (member.send(attr).nil?) ? '' : member.send(attr)
		instance_variable_set(varname, var)
	end
end

def recall_member_attribute(member, attr)
	varname = "@#{member.to_pc}"
	model = instance_variable_get(varname)
	member.should respond_to(attr)
	model["#{attr}"]
end

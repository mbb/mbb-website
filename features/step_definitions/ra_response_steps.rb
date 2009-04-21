#
# What you should see when you get there
#

Then "$actor should be at $path" do |_, path|
  response.should render_template(template_called(path))
end

Then "$actor should be redirected to $path" do |_, path|
  response.should render_template(template_called(path))
end

#
# Tags
#

Then "the page should contain '$text'" do |_, text|
  response.should have_text(/#{text}/)
end

# please note: this enforces the use of a <label> field
Then "$actor should see a <$container> containing a $attributes" do |_, container, attributes|
  attributes = attributes.to_hash_from_story
  response.should have_tag(container) do
    attributes.each do |tag, label|
      case tag
      when "textfield" then with_tag "input[type='text']";     with_tag("label", label)
      when "password"  then with_tag "input[type='password']"; with_tag("label", label)
      when "submit"    then with_tag "input[type='submit'][value='#{label}']"
      else with_tag tag, label
      end
    end
  end
end

#
# Flash messages
#

Then /^.+ should see an? (\w+) message '([\w !\'\.]+)'$/ do |notice, message|
  response.should have_flash(notice, %r{#{message}})
end

Then "$actor should not see $an $notice message '$message'" do |_, _, notice, message|
  response.should_not have_flash(notice, %r{#{message}})
end

Then "$actor should see no messages" do |_|
  ['error', 'warning', 'notice'].each do |notice|
    response.should_not have_flash(notice)
  end
end

RE_POLITENESS = /(?:please|sorry|thank(?:s| you))/i
Then %r{we should be polite about it} do
  response.should have_tag("div.error,div.notice", RE_POLITENESS)
end
Then %r{we should not even be polite about it} do
  response.should_not have_tag("div.error,div.notice", RE_POLITENESS)
end

#
# Resource's attributes
#
# "Then page should have the $resource's $attributes" is in resource_steps

# helpful debug step
Then "we dump the response" do
  dump_response
end


def have_flash notice, *args
  have_tag("div.#{notice}", *args)
end


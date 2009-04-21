require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

# Commonly used webrat steps
# http://github.com/brynary/webrat

Given /^(.*) am on (.+)$/ do |_, page_name|
  visit path_to(page_name)
end

When /^(.*) go to (.+)$/ do |_, page_name|
  visit path_to(page_name)
end

When /^(.*) press(es)? "([^\"]*)"$/ do |_, button|
  click_button(button)
end

When /^(.*) follow "([^\"]*)"$/ do |_, link|
  click_link(link)
end

When /^(.*) fills? in "([^\"]*)" with "([^\"]*)"$/ do |_, field, value|
  fill_in(field, :with => value) 
end

When /^(.*) select "([^\"]*)" from "([^\"]*)"$/ do |_, value, field|
  select(value, :from => field) 
end

# Use this step in conjunction with Rail's datetime_select helper. For example:
# When I select "December 25, 2008 10:00" as the date and time 
When /^(.*) select "([^\"]*)" as the date and time$/ do |_, time|
  select_datetime(time)
end

# Use this step when using multiple datetime_select helpers on a page or 
# you want to specify which datetime to select. Given the following view:
#   <%= f.label :preferred %><br />
#   <%= f.datetime_select :preferred %>
#   <%= f.label :alternative %><br />
#   <%= f.datetime_select :alternative %>
# The following steps would fill out the form:
# When I select "November 23, 2004 11:20" as the "Preferred" data and time
# And I select "November 25, 2004 10:30" as the "Alternative" data and time
When /^(.*) select "([^\"]*)" as the "([^\"]*)" date and time$/ do |_, datetime, datetime_label|
  select_datetime(datetime, :from => datetime_label)
end

# Use this step in conjunction with Rail's time_select helper. For example:
# When I select "2:20PM" as the time
# Note: Rail's default time helper provides 24-hour time-- not 12 hour time. Webrat
# will convert the 2:20PM to 14:20 and then select it. 
When /^(.*) select "([^\"]*)" as the time$/ do |_, time|
  select_time(time)
end

# Use this step when using multiple time_select helpers on a page or you want to
# specify the name of the time on the form.  For example:
# When I select "7:30AM" as the "Gym" time
When /^(.*) select "([^\"]*)" as the "([^\"]*)" time$/ do |_, time, time_label|
  select_time(time, :from => time_label)
end

# Use this step in conjunction with Rail's date_select helper.  For example:
# When I select "February 20, 1981" as the date
When /^(.*) select "([^\"]*)" as the date$/ do |_, date|
  select_date(date)
end

# Use this step when using multiple date_select helpers on one page or
# you want to specify the name of the date on the form. For example:
# When I select "April 26, 1982" as the "Date of Birth" date
When /^(.*) select "([^\"]*)" as the "([^\"]*)" date$/ do |_, date, date_label|
  select_date(date, :from => date_label)
end

When /^(.*) check "([^\"]*)"$/ do |_, field|
  check(field) 
end

When /^(.*) uncheck "([^\"]*)"$/ do |_, field|
  uncheck(field) 
end

When /^(.*) choose "([^\"]*)"$/ do |_, field|
  choose(field)
end

When /^(.*) attach(es)? the file at "([^\"]*)" to "([^\"]*)"$/ do |_, path, field|
  attach_file(field, path)
end

Then /^(.*) should see "([^\"]*)"$/ do |_, text|
  response.should contain(text)
end

Then /^(.*) should not see "([^\"]*)"$/ do |_, text|
  response.should_not contain(text)
end

Then /^the "([^\"]*)" checkbox should be checked$/ do |label|
  field_labeled(label).should be_checked
end

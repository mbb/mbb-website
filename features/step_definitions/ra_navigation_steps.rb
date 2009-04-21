#
# Where to go
#

#
# GET
# Go to a given page.
When /(.*) goes to (.*)( again)?/ do |actor, path, _|
  visit path_to(path)
end

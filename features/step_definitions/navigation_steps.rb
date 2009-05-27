When /(.*) goes to (.*)( again)?/ do |actor, path, _|
  visit path_to(path)
end

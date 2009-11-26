require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'news_items/index.html.erb' do
	context 'when there are no new stories' do
		before :each do
			assigns[:stories] = []
			render
		end
		
		it 'should say something with "no news at this time"' do
			response.should have_text(/no news at this time/)
		end
	end
	
	context 'when there are some news stories to show' do
		before :each do
			# Create a set of five mock stories for the view to render.
			assigns[:stories] = (1..5).to_a.collect do |story_number|
				stub_model(NewsItem,
					:title => "NewsItem ###{story_number}}",
					:date => story_number.days.ago,
					:body => "Body of story ###{story_number}."
				)				
			end
			
			render
		end

		it 'should list all the given stories' do
			response.should have_tag('ul#NewsItems') do
				with_tag('li.story', :count => assigns(:stories).length)
			end
		end
	end
end
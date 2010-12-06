require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersHelper do
	bad_identifiers = {
		'capital letters' => {'Old' => 'old'},
		'punctuation'     => {'old!' => 'old'},
		'underscores'     => {'old_slug' => 'old-slug'},
		'a period and odd format' =>
		                     {{:id => 'o', :format => '_slug'} => {:id => 'o-slug'}},
		'multiple periods' =>
		                     {{:id => 'o', :format => 'slug.html'} => {:id => 'o-slug', :format => 'html'}}
	}
	
	describe '#bad_identifier?' do
		subject { MembersHelper }
		
		bad_identifiers.each do |condition, example|
			example.each do |bad_slug, _|
				it "should recognize an old-style slug by #{condition}" do
					subject.bad_identifier?(bad_slug).should be(true)
				end
			end
		end
		
		it 'should recognize a new-style slug' do
			member = Factory(:member)
			subject.bad_identifier?(member.to_param).should be(false)
		end
	end
	
	describe '#update_identifier' do
		subject { MembersHelper }
		
		before do
			subject.stub!(:bad_identifier?).and_return(true)
		end
		
		bad_identifiers.each do |condition, examples|
			examples.each do |bad_slug, good_slug|
				it "should correct an old-style slug with #{condition}" do
					subject.update_identifier(bad_slug).should == good_slug
				end
			end
		end
	end
end

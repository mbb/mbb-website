require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersHelper do
	describe '#bad_identifier?' do
		subject { MembersHelper }
		
		it 'should recognize an old-style slug by capital letters' do
			subject.bad_identifier?('Old').should be(true)
		end
		
		it 'should recognize an old-style slug by punctuation' do
			subject.bad_identifier?('old.').should be(true)
		end
		
		it 'should recognize an old-style slug by underscores' do
			subject.bad_identifier?('old_slug').should be(true)
		end
		
		it 'should recognize a new-style slug' do
			member = Factory(:member)
			subject.bad_identifier?(member.best_id).should be(false)
		end
	end
	
	describe '#update_identifier' do
		subject { MembersHelper }
		
		bad_identifiers = {
			'capital letters' => {'Old' => 'old'},
			'punctuation'     => {'old!' => 'old'},
			'underscores'     => {'old_slug' => 'old-slug'},
			'a period and odd format' =>
			                     {{:id => 'o', :format => '_slug'} => {:id => 'o-slug'}},
			'a period and common format' =>
			                     {{:id => 'o', :format => 'html'} => {:id => 'o', :format => 'html'}},
			'multiple periods' =>
			                     {{:id => 'o', :format => 'slug.html'} => {:id => 'o-slug', :format => 'html'}}
		}
		
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
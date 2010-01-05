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
end
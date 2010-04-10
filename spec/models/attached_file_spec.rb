require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttachedFile do
	it { should belong_to(:news_item) }
	it { should validate_presence_of(:news_item) }
	it { should respond_to(:data) }
	
	# Why don't these work?!
	# it { AttachedFile.should_have_attached_file(:data) }
	# it { AttachedFile.should_validate_attachment_presence(:data) }
	
	context 'when attaching real files' do
		before :each do
			@file_with_odd_name = File.new('some awkward filen4me', File::CREAT|File::TRUNC|File::RDWR, 0644)
			@file_with_odd_name << 'Some data! Woo!'
			@file_with_odd_name.sync
		end
		
		it 'should report the file name of the attachment' do
			file = AttachedFile.new(:data => @file_with_odd_name)
			file.file_name.should == @file_with_odd_name.path
		end
		
		it 'should report a direct url for the attachment' do
			file = AttachedFile.new(:data => @file_with_odd_name)
			file.data.should respond_to(:url)
		end
	end
end

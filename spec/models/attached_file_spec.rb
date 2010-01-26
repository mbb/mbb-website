require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttachedFile do
	it { should belong_to(:news_item) }
	it { should validate_presence_of(:news_item) }
	it { should respond_to(:data) }
	
	it 'should report the file name of the attachment'
	it 'should report a direct url for the attachment'
end

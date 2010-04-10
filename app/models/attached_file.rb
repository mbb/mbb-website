require 'paperclip_filename'

class AttachedFile < ActiveRecord::Base
	belongs_to :news_item
	validates_presence_of :news_item
	has_attached_file :data,
		:path => ':rails_root/public/assets/:class/:id/:basename.:extension',
		:url => '/assets/:class/:id/:basename.:extension'
	validates_attachment_presence :data
	
	def file_name
		data_file_name
	end
end

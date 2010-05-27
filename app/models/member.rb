require 'digest/sha1'
require 'mbb/phone_number'
require 'threedegrees/regex'

class Member < ActiveRecord::Base
	acts_as_authentic do |config|
		config.transition_from_restful_authentication = true
	end
	
	has_friendly_id :name, :use_slug => true
	belongs_to :section
	acts_as_list :scope => :section_id
	before_validation :set_default_position
	default_scope :order => 'position ASC'
	named_scope :visible, :conditions => {:visible => true}
	named_scope :invisible, :conditions => {:visible => false}
	
	has_and_belongs_to_many :roles
	has_attached_file :photo,
		:url => '/assets/:class/:attachment/:id/:style/:basename.:extension',
		:path => ':rails_root/public/assets/:class/:attachment/:id/:style/:basename.:extension',
		:default_url => '/assets/:class/:attachment/missing_:style.jpg',
		:styles =>	{
			:headshot => '300x300#',
			:thumbnail => '100x100#',
			:tiny => '50x50#'
		}
	before_validation do |record|
		if record.crypted_password.blank? and record.password.blank?
			record.password_is_temporary = true
			record.password = default_password
			record.password_confirmation = default_password
		end
	end
	
	FirstName = /([\w\.]+)/
	MiddleNames = /\s([\w\s\.]+)/
	LastName = /\s([\w\.]+)/
	FullName = /#{FirstName} #{MiddleNames}? #{LastName}/x
	
	validates_length_of      :name, :maximum => 100
	validates_presence_of    :name
	validates_format_of      :name, :with => FullName
	validates_uniqueness_of  :name
	validates_presence_of    :email
	validates_format_of      :phone_number, :with => ThreeDegrees::Regex::phone_number, :allow_blank => true
	validates_presence_of    :section
	
	def neighbors(load_eagerly = false)
		[higher_item, lower_item].compact
	end
	
	alias_method :raw_section=, :section=
	def section=(new_section_object)
		old_section = self.section
		
		unless self.new_record? || old_section.nil?
			new_section = new_section_object
			self.remove_from_list unless old_section.nil?
			self.raw_section = new_section
			
			# Place the member somewhere in the order within the new section. This must
			# be done explicitly to avoid using the position from the old section (which
			# will probably be invalid or duplicate another member's position).
			if new_section.members.count > 0
				if (not old_section.nil?) and new_section.position < old_section.position
					self.insert_at(new_section.members.last.position + 1) # Move up to "bottom" of higher section
				else
					self.insert_at(1)
				end
			else
				self.insert_at(1)
			end
		else
			self.raw_section = new_section_object
		end
	end
	
	def pretty_phone_number
		MadisonBrassBand::PhoneNumber.to_display(self.attributes['phone_number'])
	end
	
	def to_s
		name
	end
	
	def to_json
		super(:except => [:crypted_password, :salt, :perishable_token,
		                 :persistence_token, :remember_token, :remember_token_expires_at,
		                 :photo_file_name, :photo_file_size, :photo_content_type])
	end
	
	def self.default_password
		'brass4life'
	end
	
	def set_default_position
		if position.blank? and not section.blank?
			unless section.members.count == 0
				write_attribute('position', section.members.last.position + 1)
			else
				write_attribute('position', 1)
			end
		end
	end
end

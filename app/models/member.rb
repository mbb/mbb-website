require 'digest/sha1'

class Member < ActiveRecord::Base
	include Authentication
	include Authentication::ByPassword
	include Authentication::ByCookieToken

	belongs_to :section
	has_and_belongs_to_many :roles
	has_attached_file :photo, :styles =>	{
		:headshot => '212x287#',
		:thumbnail => '80x80#'
	}
	before_validation_on_create do |record|
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

	validates_length_of			 :name,	:maximum => 100
	validates_presence_of		 :name
	validates_format_of			 :name,	:with => FullName
	validates_uniqueness_of  :name	
	validates_presence_of		 :email
	validates_length_of			 :email, :within => 6..100
	validates_uniqueness_of	 :email
	validates_format_of			 :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message
	validates_presence_of    :section

	def to_pc
		self.class.to_pc(name)
	end

	def self.find_by_path_component(component)
		self.find_by_name(component.humanize.titleize)
	end

	def to_param
		to_pc
	end

	def to_s
		name
	end

	# prevents a user from submitting a crafted form that bypasses activation
	# anything else you want your user to change should be added here.
	attr_accessible :email, :name, :password, :password_confirmation, :section, :section_id,
		:roles, :updated_at, :created_at, :photo, :biography

	# Authenticates a user by their login name and unencrypted password.	Returns the user or nil.
	#
	# uff.	this is really an authorization, not authentication routine.	
	# We really need a Dispatch Chain here or something.
	# This will also let us return a human error message.
	#
	def self.authenticate(name, password)
		return nil if name.blank? || password.blank?
		u = find_by_name(name) # need to get the salt
		u && u.authenticated?(password) ? u : nil
	end

	def login=(value)
		write_attribute :login, (value ? value.downcase : nil)
	end

	def email=(value)
		write_attribute :email, (value ? value.downcase : nil)
	end
	
	def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end

	def self.default_password
		'brass4life'
	end
	
	# Turns Andres J. Tack into andres_j._tack
	# (pc => "path component")
	def self.to_pc(name)
		name.gsub(' ', '_').downcase
	end
end

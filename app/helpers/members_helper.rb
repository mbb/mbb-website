module MembersHelper
	def self.bad_identifier?(identifier)
		Member.find(:first, :conditions => {:slugs => {:name => identifier}}, :joins => 'JOIN slugs').nil?
	end
end
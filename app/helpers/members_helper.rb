module MembersHelper
	def self.bad_identifier?(identifier)
		Member.find(:first, :conditions => {:slugs => {:name => identifier}}, :joins => 'JOIN slugs').nil?
	end
	
	# Constructs a good identifier from a bad one, given the either a string parameter
	# or a hash in the format of a request parameter hash. If a hash is given, the
	# id will be selected using the entry at key <tt>:id</tt>.
	#
	#   params = {:id => 'Andres_J', :format => '_Tack'}
	#   MembersHelper.good_identifier(params)       # => {:id => 'andres-j-tack'}
	#   MembersHelper.good_identifier(params[:id])  # => 'andres-j'
	#
	#   params[:format] = 'html'
	#   MembersHelper.good_identifier(params)       # => {:id => 'andres-j', :format => 'html'}
	#
	# The returned string may not be a different identifier. One should be sure to
	# test for this case to avoid an infinite loop of redirects.
	def self.update_identifier(source)
		new_identifier = case source
			when String
				sans_underscores = spacerize(source)
				new_slug = Slug.normalize(sans_underscores)
			when Hash
				slug_string = spacerize(source[:id])
				
				if source.has_key?(:format) and not mime_type_exists?(source[:format])
					split_format = source[:format].split('.', 2)
					extra_id = spacerize(split_format.first)
					normalized = Slug.normalize("#{slug_string} #{extra_id}")
					
					if split_format.length > 1
						source.merge(:id => normalized, :format => split_format.last)
					else
						hash = source.merge(:id => normalized)
						hash.delete(:format)
						hash
					end
				else
					normalized = Slug.normalize(slug_string)
					source.merge(:id => normalized)
				end
			end
	end
	
	private
		def self.mime_type_exists?(format)
			Mime::EXTENSION_LOOKUP.has_key?(format)
		end
		
		def self.spacerize(x)
			x.gsub('_', ' ')
		end
end
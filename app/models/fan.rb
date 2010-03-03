# A fan of the Madison Brass Band is anyone appearing on our drip e-mail
# list. Fans can receive e-mail, but it is our responsibility not to
# annoy them.
class Fan < ActiveRecord::Base
	validates_presence_of :email
	validates_format_of :email, :with => Authlogic::Regex.email
	
	def to_s
		email
	end
end

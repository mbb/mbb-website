module HomeHelper
	def next_concert_image
		image_tag 'band_at_us_open.png', :class => 'thumbnail',
			:alt => 'The band performing in a standing arrangement, in tuxedos.'
	end
end

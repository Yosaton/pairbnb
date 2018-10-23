class Listing < ApplicationRecord

	
	# Associations
	has_many 	:bookings 
	has_many	:listing_photos
	belongs_to 	:user
end

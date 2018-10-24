class Listing < ApplicationRecord
	# Validations
	validates_length_of :name, minimum: 1
	validates :capacity, numericality: {greater_than: 0}
	validates :price, numericality: {greater_than: 0}
	validates :rating, numericality: {greater_than: -1}
	validates :rating, numericality: {less_than: 6}
	
	# Associations
	has_many 	:bookings 
	has_many	:listing_photos
	belongs_to 	:user


	# Constant Symbols hash
	SYMBOLS = {rating_star: "🌟", rating_empty: "⚬", capacity: "😃", price_icon: "💰", verified: "👍"}


	# Function Definitions
	def symbolize_rating
		x = (SYMBOLS[:rating_empty] * 5).split("")

		rating.times do |i|
			x[i] = SYMBOLS[:rating_star]
		end

		return x.join("")
	end


	def symbolize_capacity
		return "#{SYMBOLS[:capacity]} #{capacity}"
	end


	def name_with_verification
		return "#{display_badge_if_verified} #{name} #{display_badge_if_verified}"
	end

	def name_with_verification_right
		return "#{name} #{display_badge_if_verified}"
	end


	private
	def display_badge_if_verified
		if(is_verified)
			return SYMBOLS[:verified]
		else
			return ""
		end
	end
end

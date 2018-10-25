class Listing < ApplicationRecord
	# Validations
	YES_VALIDATE = Listing.attribute_names
	NO_VALIDATE = ["is_verified", "id", "created_at", "updated_at"]

	VALIDATE = YES_VALIDATE - NO_VALIDATE

	validates_presence_of VALIDATE

	validates_length_of :name, minimum: 1
	validates :capacity, numericality: {greater_than: 0}
	validates :price, numericality: {greater_than: 0}
	validates :rating, numericality: {greater_than: -1}
	validates :rating, numericality: {less_than: 6}
	
	# Associations
	has_many 	:bookings 
	has_many	:listing_photos
	has_many :taggings
	has_many :tags, :through => :taggings
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

    # Max photos 8
    def can_add_more_photos?
      return (listing_photos.length <= 7)? true : false
    end 


    def tagline
    	last_period = (tags.length == 0)? "" : "."
    	return tags.map { |t|  t.text}.join(". ") + last_period
    end

    def tagline_space_delimited
    	return tags.map { |t|  t.text}.join(" ")
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

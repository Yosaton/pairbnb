class Listing < ApplicationRecord
	# Validations
	YES_VALIDATE = Listing.attribute_names
	NO_VALIDATE = ["is_verified", "id", "created_at", "updated_at"]
	AMENITIES = ["has_essentials", "has_airconditioner", "has_washer_dryer", "has_television", "has_fireplace", "has_wifi", "has_hot_water", "has_kitchen", "has_heating", "has_living_room"]

	VALIDATE = YES_VALIDATE - NO_VALIDATE - AMENITIES

	validates_presence_of VALIDATE

	validates_length_of :name, minimum: 3
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
	SYMBOLS = {rating_star: "🌟", rating_empty: "⚬", capacity: "😃", price_icon: "💰", verified: "👍", bed: "🛏️", bath: "🚽", tick: "🗸"}
	AMENITIES = {essentials: "🍃", airconditioner: "❄️", washer_dryer: "👕", television: "📺", fireplace: "🔥", wifi: "📶", hot_water: "🚰", kitchen: "🍳", heating: "♨️", living_room: "☕"}
	PROPERTY_TYPES = ["", "House", "Entire Floor", "Condominium", "Villa", "Townhouse", "Castle", "Treehouse", "Igloo", "Yurt", "Cave", "Chalet", "Hut", "Tent", "Other"]

	# Scopes for searching
	# scope :keywords, -> (keywords) { where("LOWER(name) LIKE ?", "%#{keywords.downcase}%")}
	scope :property_type, -> (property_type) { where property_type: property_type }
	scope :country, -> (country) { where country: country }
	scope :max_price, -> (max_price) { where("price <= ?", max_price) }
	scope :n_bedrooms, -> (n_bedrooms) { where n_bedrooms: n_bedrooms }
	scope :n_bathrooms, -> (n_bathrooms) { where n_bathrooms: n_bathrooms }

	scope :has_essentials, -> (has_essentials) { where has_essentials: has_essentials }
	scope :has_airconditioner, -> (has_airconditioner) { where has_airconditioner: has_airconditioner }
	scope :has_washer_dryer, -> (has_washer_dryer) { where has_washer_dryer: has_washer_dryer }
	scope :has_television, -> (has_television) { where has_television: has_television }
	scope :has_fireplace, -> (has_fireplace) { where has_fireplace: has_fireplace }
	scope :has_wifi, -> (has_wifi) { where has_wifi: has_wifi }
	scope :has_hot_water, -> (has_hot_water) { where has_hot_water: has_hot_water }
	scope :has_kitchen, -> (has_kitchen) { where has_kitchen: has_kitchen }
	scope :has_heating, -> (has_heating) { where has_heating: has_heating }
	scope :has_living_room, -> (has_living_room) { where has_living_room: has_living_room }

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

    def has_bookings_between(start_date, end_date)
    	if(start_date.strip != "" && end_date.strip != "")
	    	bookings.each do |booking|
	    		if(start_date.to_date <= booking.end_date.to_date && booking.start_date.to_date <= end_date.to_date) # if true, overlap found
	    			return true
	    		else
	    			next
	    		end
	    	end
	    end
    	return false
    end

    def amenity_string
    	result = []

		Listing::AMENITIES.each do |key, value|
			if (send("has_#{key}") == true)
				result << value				
			end 
		end

		return result.join(" ")
    end


    def amenity_write
    	result = ["#{Listing::SYMBOLS[:tick]}"]

		Listing::AMENITIES.each do |key, value|
			if (send("has_#{key}") == true)
				result << key.capitalize.to_s.gsub("_", " ")			
			end 
		end

		result << "#{Listing::SYMBOLS[:tick]}"

		return result.join(" #{Listing::SYMBOLS[:tick]} ")
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

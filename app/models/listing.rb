class Listing < ApplicationRecord
	include PgSearch

	# Validations
	YES_VALIDATE = Listing.attribute_names
	NO_VALIDATE = ["is_verified", "id", "created_at", "updated_at", "smoking_allowed"]
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
	SYMBOLS = { rating_star: "fas fa-star",
				rating_empty: "far fa-star",
				capacity: "fas fa-user",
				price_icon: "fas fa-money-bill",
				verified: "fas fa-check-circle fa-xs",
				bed: "fas fa-bed",
				bath: "fas fa-toilet-paper",
				tick: "🗸",
				no_smoking: "fas fa-smoking-ban fa-xs"
			}

	AMENITIES = { 	essentials: "fas fa-leaf",
					airconditioner: "far fa-snowflake",
					washer_dryer: "fas fa-tshirt",
					television: "fas fa-tv",
					fireplace: "fas fa-fire",
					wifi: "fas fa-wifi",
					hot_water: "fas fa-shower",
					kitchen: "fas fa-utensils",
					heating: "fas fa-thermometer-three-quarters",
					living_room: "fas fa-coffee"
				}

	PROPERTY_TYPES = [	"",
						"House",
						"Entire Floor",
						"Condominium",
						"Villa",
						"Townhouse",
						"Castle",
						"Treehouse",
						"Igloo",
						"Yurt",
						"Cave",
						"Chalet",
						"Hut",
						"Tent",
						"Other"
					]

	# Scopes for searching
	# scope :keywords, -> (keywords) { where("LOWER(name) LIKE ?", "%#{keywords.downcase}%")}
	scope :property_type, -> (property_type) { where property_type: property_type }
	scope :country, -> (country) { where country: country }
	scope :max_price, -> (max_price) { where("price <= ?", max_price) }
	scope :n_bedrooms, -> (n_bedrooms) { where n_bedrooms: n_bedrooms }
	scope :n_bathrooms, -> (n_bathrooms) { where n_bathrooms: n_bathrooms }
	scope :smoking_allowed, -> (smoking_allowed) { where smoking_allowed: smoking_allowed}

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

	# PG Search scopes for text_searches
	pg_search_scope :search_keywords, :against => :name, using: { tsearch: { any_word: true, prefix: true } }
	pg_search_scope :search_tags, :associated_against => {:tags => [:text]}

	# Function Definitions

	# Rendering Functions
	def self.display_fa_icon(symbol)
		return "<i class='#{AMENITIES[symbol.to_sym]}'></i>".html_safe
	end

	def self.display_fa_icon_symbols(symbol)
		return "<i class='#{SYMBOLS[symbol.to_sym]}'></i>".html_safe
	end

	def symbolize_rating
		x = [fetch_font_awesome_class("symbols", :rating_empty)] * 5

		rating.times do |i|
			x[i] = fetch_font_awesome_class("symbols", :rating_star)
		end

		return render_font_awesome_string(x).join("").html_safe
	end

	def symbolize_capacity
		return "#{render_font_awesome_string([fetch_font_awesome_class("symbols", :capacity)]).join("")} #{capacity}".html_safe
	end

    def amenity_string
    	result = []

		Listing::AMENITIES.each do |key, value|
			if (send("has_#{key}") == true)
				result << value
			end
		end

		return render_font_awesome_string(result).join(" ").html_safe
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


	def smoking_badge
    	return (smoking_allowed)? "" : render_font_awesome_string([fetch_font_awesome_class("symbols", :no_smoking)]).join("").html_safe
    end


	def name_with_verification
		return "#{display_badge_if_verified} #{name} #{display_badge_if_verified}".html_safe
	end

	def name_with_verification_right
		return "#{name} #{display_badge_if_verified}".html_safe
	end

    def tagline
    	last_period = (tags.length == 0)? "" : "."
    	return tags.map { |t|  t.text}.join(". ") + last_period
    end

    def tagline_space_delimited
    	return tags.map { |t|  t.text}.join(" ")
    end



    # Validation etc functions
    # Max photos 8
    def can_add_more_photos?
      return (listing_photos.length <= 7)? true : false
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


	private
	def display_badge_if_verified
		if(is_verified)
			return "<i class='#{SYMBOLS[:verified]}' style='color: #35c2ff'></i>"
		else
			return ""
		end
	end

	# Returns the HTML class needed for the <i> tag to display the icon!
	def fetch_font_awesome_class(source, symbol)
		case source.downcase
		when "symbols"
			return "#{SYMBOLS[symbol.to_sym]}"

		when "amenities"
			return "#{AMENITIES[symbol.to_sym]}"
		end
	end

	# Takes array of font awesome classes, wraps each in its own <i> tag and returns as array
	def render_font_awesome_string(array_of_fa_classes)
		return array_of_fa_classes.map {|e| "<i class='#{e}'></i>"}
	end
end

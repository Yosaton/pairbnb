class Booking < ApplicationRecord
	# Associations
	belongs_to 	:user 
	belongs_to	:listing

	#validations
	validates :start_date, :end_date, presence: true
	validate :end_after_start
	validate :booking_does_not_clash

	# Functions
	# Multiplies price per night by the number of days the booking is for to get total price.
	def calculate_total_price(listing_price)
		# Subtracting dates as Time objects, so difference is in SECONDS
		return (days_of_booking) * listing_price
	end


	def c_t_p
		return (days_of_booking) * listing.price
	end


	# How long is the booking?
	def days_of_booking
		return (((end_date - start_date) / 60 / 60 / 24) + 1).to_i
	end

	def payment_status
		return (is_paid)? "PAID" : "UNPAID"
	end

	private

	def end_after_start
		return if end_date.blank? || start_date.blank?

		if end_date < start_date + 1
		errors.add(:end_date, "must be after the start date") 
		end 
	end

	def booking_does_not_clash
		# First, get all the bookings for a particular listing
		# Then, compare the current bookings start and end dates with all the others (looking for clashes)
		related_bookings = Booking.where(listing_id: listing_id)
		this_booking = Booking.where(id: id)

		check_bookings = related_bookings - this_booking
		
		check_bookings.each do |booking|
			
			if (start_date <= booking.end_date && booking.start_date <= end_date) # Overlap found if condition is true
				# Handling overlap: not allowed to save!
				errors.add(:booking_date, "overlaps with another booking!")
			end
		end
	end

end

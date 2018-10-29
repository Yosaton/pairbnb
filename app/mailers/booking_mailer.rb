class BookingMailer < ApplicationMailer
	default from: 'dustincrs.next@gmail.com'

	def new_booking_email(booking)
		@booking = booking
		mail(to: @booking.listing.user.email, subject: "Hey #{@booking.listing.user.full_name}, you have a new guest!")
	end
end

class BookingJob < ApplicationJob
  queue_as :default

  def perform(booking, status)
  	@booking = booking

  	case status

  	when "new"
		BookingMailer.new_booking_email(@booking).deliver!

	when "paid"
		BookingMailer.paid_booking_email(@booking).deliver!
	end
	
  end
end

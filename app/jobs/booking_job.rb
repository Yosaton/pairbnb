class BookingJob < ApplicationJob
  queue_as :default

  def perform(booking)
  	@booking = booking
  	p "IN BOOKING JOB PERFORM!"
    BookingMailer.new_booking_email(@booking).deliver!
  end
end

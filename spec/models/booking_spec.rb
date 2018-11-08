require 'rails_helper'

RSpec.describe Booking, type: :model do

	# Invocation of let() is lazy. Use let! to make them all run immediately!
	let!(:user_create){User.new().save(:validate => false)}
	let!(:listing_create){Listing.new().save(:validate => false)}
	let!(:user){User.all.last}
	let!(:listing){Listing.all.last}

	let!(:booking_1){Booking.create(start_date: Date.today, end_date: 3.days.from_now, user_id: user.id, listing_id: listing.id, price: 420)}
	let!(:booking_2){Booking.create(start_date: 5.days.from_now, end_date: 8.days.from_now, user_id: user.id, listing_id: listing.id, price: 420)}
	let!(:booking_3){Booking.create(start_date: 1.days.from_now, end_date: 4.days.from_now, user_id: user.id, listing_id: listing.id, price: 420)}

	describe "date validations" do
		context "clashes" do

			it "should pass if the date ranges do not clash" do
				expect(booking_2).to be_valid
				expect(booking_2.errors.messages[:booking_date]).to eq([])
			end
		
			it "should fail if date ranges clash" do
				expect(booking_3).to_not be_valid
				expect(booking_3.errors.messages[:booking_date]).to eq(['overlaps with another booking!'])
			end
		end
	end
end

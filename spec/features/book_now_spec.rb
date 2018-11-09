require 'rails_helper'

RSpec.feature "Book Now Button", type: :feature do

	User.new().save(:validate => false)
	User.new().save(:validate => false)
	let!(:user){User.all.last}

	Listing.new(user_id: User.all.first.id, description: "fuck", name: "shit").save(:validate => false)
	let!(:listing){Listing.all.last}

  context "when clicked" do

    it "with sign-in, should go to new booking page" do
      visit listing_path(listing.id, as: user)
      click_link "book-now-link"
      expect(current_path).to eq(new_booking_path)
    end

    it "without sign-in, should go to sign-in page" do
      visit "/listings/#{listing.id}"
      click_link "book-now-link"
      expect(current_path).to eq(sign_in_path)
    end

  end
end

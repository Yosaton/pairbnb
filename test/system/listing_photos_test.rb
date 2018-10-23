require "application_system_test_case"

class ListingPhotosTest < ApplicationSystemTestCase
  setup do
    @listing_photo = listing_photos(:one)
  end

  test "visiting the index" do
    visit listing_photos_url
    assert_selector "h1", text: "Listing Photos"
  end

  test "creating a Listing photo" do
    visit listing_photos_url
    click_on "New Listing Photo"

    click_on "Create Listing photo"

    assert_text "Listing photo was successfully created"
    click_on "Back"
  end

  test "updating a Listing photo" do
    visit listing_photos_url
    click_on "Edit", match: :first

    click_on "Update Listing photo"

    assert_text "Listing photo was successfully updated"
    click_on "Back"
  end

  test "destroying a Listing photo" do
    visit listing_photos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Listing photo was successfully destroyed"
  end
end

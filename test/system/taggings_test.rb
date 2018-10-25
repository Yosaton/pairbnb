require "application_system_test_case"

class TaggingsTest < ApplicationSystemTestCase
  setup do
    @tagging = taggings(:one)
  end

  test "visiting the index" do
    visit taggings_url
    assert_selector "h1", text: "Taggings"
  end

  test "creating a Tagging" do
    visit taggings_url
    click_on "New Tagging"

    click_on "Create Tagging"

    assert_text "Tagging was successfully created"
    click_on "Back"
  end

  test "updating a Tagging" do
    visit taggings_url
    click_on "Edit", match: :first

    click_on "Update Tagging"

    assert_text "Tagging was successfully updated"
    click_on "Back"
  end

  test "destroying a Tagging" do
    visit taggings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tagging was successfully destroyed"
  end
end

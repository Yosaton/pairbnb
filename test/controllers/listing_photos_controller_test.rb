require 'test_helper'

class ListingPhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @listing_photo = listing_photos(:one)
  end

  test "should get index" do
    get listing_photos_url
    assert_response :success
  end

  test "should get new" do
    get new_listing_photo_url
    assert_response :success
  end

  test "should create listing_photo" do
    assert_difference('ListingPhoto.count') do
      post listing_photos_url, params: { listing_photo: {  } }
    end

    assert_redirected_to listing_photo_url(ListingPhoto.last)
  end

  test "should show listing_photo" do
    get listing_photo_url(@listing_photo)
    assert_response :success
  end

  test "should get edit" do
    get edit_listing_photo_url(@listing_photo)
    assert_response :success
  end

  test "should update listing_photo" do
    patch listing_photo_url(@listing_photo), params: { listing_photo: {  } }
    assert_redirected_to listing_photo_url(@listing_photo)
  end

  test "should destroy listing_photo" do
    assert_difference('ListingPhoto.count', -1) do
      delete listing_photo_url(@listing_photo)
    end

    assert_redirected_to listing_photos_url
  end
end

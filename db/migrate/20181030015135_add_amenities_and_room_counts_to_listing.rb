class AddAmenitiesAndRoomCountsToListing < ActiveRecord::Migration[5.2]
  def change
  	add_column(:listings, :n_bedrooms, :integer)
  	add_column(:listings, :n_bathrooms, :integer)

  	add_column(:listings, :has_essentials, :boolean, default: false)
  	add_column(:listings, :has_airconditioner, :boolean, default: false)
  	add_column(:listings, :has_washer_dryer, :boolean, default: false)
  	add_column(:listings, :has_television, :boolean, default: false)
  	add_column(:listings, :has_fireplace, :boolean, default: false)
  	add_column(:listings, :has_wifi, :boolean, default: false)
  	add_column(:listings, :has_hot_water, :boolean, default: false)
  	add_column(:listings, :has_kitchen, :boolean, default: false)
  	add_column(:listings, :has_heating, :boolean, default: false)
  	add_column(:listings, :has_living_room, :boolean, default: false)
  end
end

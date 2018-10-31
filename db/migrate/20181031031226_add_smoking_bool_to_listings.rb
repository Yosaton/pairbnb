class AddSmokingBoolToListings < ActiveRecord::Migration[5.2]
  def change
  	add_column(:listings, :smoking_allowed, :boolean, default: false)
  end
end

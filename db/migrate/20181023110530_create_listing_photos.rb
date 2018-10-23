class CreateListingPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :listing_photos do |t|

      t.timestamps
    end
  end
end

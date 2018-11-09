class IndexAllForeignKeys < ActiveRecord::Migration[5.2]
  def change
  	add_index :avatars,			:user_id
  	add_index :bookings,		:user_id
  	add_index :bookings,		:listing_id
  	add_index :listing_photos,	:listing_id
  	add_index :listings,		:user_id
  	add_index :taggings,		:listing_id
  	add_index :taggings,		:tag_id
  end
end

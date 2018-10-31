class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
    	t.string :text

    	t.timestamps
    end


    create_table :listings_tags do |t|
    	t.integer :listing_id
    	t.integer :tag_id

    	t.timestamps
    end
  end
end

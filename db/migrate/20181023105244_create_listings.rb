class CreateListings < ActiveRecord::Migration[5.2]
	def change
		create_table :listings do |t|
			t.string 	:name
			t.string 	:property_type
			t.string 	:address
			t.string 	:city
			t.string 	:country
			t.integer 	:price
			t.integer	:capacity
			t.integer 	:rating, default: 0
			t.string 	:description
			t.boolean 	:is_verified, default: false
			t.integer 	:user_id

			t.timestamps
		end
	end
end

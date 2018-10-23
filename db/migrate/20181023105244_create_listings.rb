class CreateListings < ActiveRecord::Migration[5.2]
	def change
		create_table :listings do |t|
			t.string 	:name
			t.string 	:address
			t.string 	:city
			t.string 	:country
			t.integer 	:price
			t.integer	:capacity
			t.integer 	:rating, default: 0

			t.timestamps
		end
	end
end

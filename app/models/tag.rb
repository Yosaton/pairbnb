class Tag < ApplicationRecord
	# Associations
	has_many :taggings
	has_many :listings, :through => :taggings

	#validations
	validates_length_of :text, minimum: 1, maximum: 10
end

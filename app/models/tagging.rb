class Tagging < ApplicationRecord
	#associations
	belongs_to :listing
	belongs_to :tag
end

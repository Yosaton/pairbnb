class ListingPhoto < ApplicationRecord
	belongs_to :listing

	mount_uploader :photo, ListingPhotoUploader
end
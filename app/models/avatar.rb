class Avatar < ApplicationRecord
	belongs_to :user

	mount_uploader :avatar_image, AvatarUploader
end

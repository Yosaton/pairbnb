class Chatroom < ApplicationRecord
	has_many :subscriptions
	has_many :messages
end

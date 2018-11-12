class Chatroom < ApplicationRecord
	has_many :subscriptions
	has_many :messages
	has_many :users, through: :subscriptions

	validates :name, presence: true, uniqueness: true
end

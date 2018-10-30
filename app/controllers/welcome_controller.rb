class WelcomeController < ApplicationController

	def index
		@featured_listing = Listing.where("rating > ?", 3).sample
	end
	
end
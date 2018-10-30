class SearchController < ApplicationController
  def show
  	@results = Listing.where(nil)

	# Values for the checkboxes are "0" and "1", so lets handle them separately
  	search_params.each do |key, value|
		@results = @results.public_send(key, value) if value.present? 
  	end

  	# Here, we handle searching for the amenities. Ignore "0", search when we have "1"s
  	search_amenities_params.each do |key, value|
  		if(value == "1")
  			@results = @results.public_send(key, value) if value.present?
  		end
  	end

  	@total_results = @results.length
    @results = @results.order(:rating).page params[:page]

  end


  private

  def search_params
  	params.require(:search).permit(:keywords, :country, :max_price, :n_bedrooms, :n_bathrooms)
  end

  def search_amenities_params
  	params.require(:search).permit(:has_essentials, :has_airconditioner, :has_washer_dryer, :has_television, :has_fireplace, :has_wifi, :has_hot_water, :has_kitchen, :has_heating, :has_living_room)
  end
end

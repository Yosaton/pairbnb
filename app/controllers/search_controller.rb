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


  def text_search
    @results = Listing.where(id: get_text_search_results)
    @total_results = @results.length
    @results = @results.order(:rating).page params[:page]
    render :show
    
  end

  def text_search_ajax
    @results = Listing.where(id: get_text_search_results).limit(5)
    @results = @results.order(:rating)
    render status: 200, json: @results.as_json
  end


  private

  def get_text_search_results
    all_keywords = text_search_params[:keywords].strip.split(" ") # Array of words from search box

    results = Listing.where(nil)

    results_from_name_search = []
    results_from_tag_search = []

    all_keywords.each do |keyword|
      results_from_name_search << results.search_keywords(keyword).map { |e|  e.id} if !results.search_keywords(keyword).empty?
      results_from_tag_search << results.search_tags(keyword).map { |e|  e.id} if !results.search_tags(keyword).empty?
    end

    results = results_from_name_search + results_from_tag_search
    return results.flatten!
  end


  def search_params
  	params.require(:search).permit(:property_type, :country, :max_price, :n_bedrooms, :n_bathrooms, :smoking_allowed)
  end

  def search_amenities_params
  	params.require(:search).permit(:has_essentials, :has_airconditioner, :has_washer_dryer, :has_television, :has_fireplace, :has_wifi, :has_hot_water, :has_kitchen, :has_heating, :has_living_room)
  end

  def text_search_params
    params.require(:text_search).permit(:keywords)
  end
end

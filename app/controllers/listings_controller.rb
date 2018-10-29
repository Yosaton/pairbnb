class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy, :verify]

  # GET /listings
  # GET /listings.json
  def index
    p search_params
    @listings = Listing.where(city: search_params[:city]).page params[:page] 

    @listings.each do |listing| # For each listing in the city desired...
      
      if(listing.has_bookings_between(search_params[:start_date], search_params[:end_date]))
        # If that listing has a booking in the date range specified, we need to reject it
        @listings -= [listing]
      else
        # Otherwise, business as normal
        next
      end
    end

    @text_injection = (search_params[:start_date].blank? && search_params[:end_date].blank?)? "" : "from #{params[:search][:start_date].to_date} to #{params[:search][:end_date].to_date}"

  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    @listing_images = @listing.listing_photos.shuffle
    @random_main_image = @listing_images.pop

    @related_listings = []

    @listing.tags.each do |tag|
      @related_listings << tag.listings
    end

    @related_listings.flatten!
    @related_listings = @related_listings.uniq
    @related_listings -= [@listing]
    @related_listings = @related_listings.sample(6)

    @booking_button_href = "#{new_booking_path}?listing_id=#{@listing.id}"
    @booking_button_text = "Book now!"


    # HEY DUSTIN if the current user has a booking where the start date is later than Date.today, THEN..
    # change the href and text to suit.... (the view should already accomodate this, just work out the IF
    # condition and what to change href and shit to)
    if(signed_in?)
      current_user.bookings.order(:start_date).each do |booking|
        if(booking.listing.id == @listing.id)

          if(booking.start_date >= Date.today)
            @booking_button_href = "#{booking_path(booking.id)}"
            @booking_button_text = "You have already booked this listing from #{booking.start_date} to #{booking.end_date}."
            break
          end
        end
      end
    end

  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  # POST /listings.json
  def create
    max_photos_notice = ""

    @listing = Listing.new(listing_params)
    @listing.user_id = current_user.id

    respond_to do |format|
      if @listing.save

        # Handle image uploads (must be done after the user is saved)
        if(listing_photo_params[:photos] != nil)
          listing_photo_params[:photos].each do |photo|
            if(@listing.can_add_more_photos?)
              new_photo = ListingPhoto.new(photo: photo)
              new_photo.listing_id = @listing.id
              new_photo.save
              @listing = Listing.find_by_id(@listing.id) # Need to re-get reference to @listing to update the picture count
            else
              max_photos_notice = "However, maximum photos limit exceeded. Images over the limit were ignored."
            end
          end
        end


        # Handle tagging
        loop_and_assign_tags


        format.html { redirect_to @listing, notice: "Listing was successfully created. #{max_photos_notice}" }
        format.json { render :show, status: :created, location: @listing }

      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end


  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update

    # Handle photo deletion before adding new shit
    if(delete_photo_params[:delete_images] != nil)
      delete_photo_params[:delete_images].keys.each do |listing_photo_id|
        photo = ListingPhoto.find_by_id(listing_photo_id.to_i)
        photo.destroy
      end
    end

    max_photos_notice = ""
    # If updating, just add more new photos that are uploaded
    if(listing_photo_params[:photos] != nil)

      listing_photo_params[:photos].each do |photo|
        if(@listing.can_add_more_photos?)
          new_photo = ListingPhoto.new(photo: photo)
          new_photo.listing_id = @listing.id
          new_photo.save
          @listing = Listing.find_by_id(@listing.id) # Need to re-get reference to @listing to update the picture count        else
        else
          max_photos_notice = "However, exceeded maximum photos limit of 8. Images over the limit were ignored."
        end

      end
    end


    # Handle Tagging
    # Only 3 tags per listing, so before we do the shit to add new tags, remove the old ones
    @listing.taggings.each do |tagging|
      tagging.destroy
    end
    
    loop_and_assign_tags

    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to listing_path(@listing.id), notice: "Listing was successfully updated. #{max_photos_notice}" }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Listing was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  # For toggling the is_verified of a listing
  # POST
  def verify
    @listing.is_verified = !@listing.is_verified
    if(@listing.save)
      flash[:success] = "Listing is_verified is now #{@listing.is_verified}"
    else
      flash[:error] = "Failed to verify/unverify listing. #{@listing.errors.full_messages}"
    end

    redirect_to listing_path(@listing.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    def loop_and_assign_tags
      listing_tag_params[:tags].values.reject{|t| t.strip.empty?}.each do |tag_text| # iterate over all non-empty members

      db_tag = Tag.find_by(text: tag_text)

      if(db_tag != nil)
          # Tag exists! Do nothing.
          
      else
          # Tag doesn't exist! Create new tag
        db_tag = Tag.create(text: tag_text)

      end

        Tagging.create(listing_id: @listing.id, tag_id: db_tag.id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:name, :property_type, :address, :city, :country, :price, :capacity, :description)
    end

    def listing_photo_params
      params.require(:listing).permit(photos: [])
    end

    def delete_photo_params
      params.require(:listing).permit(delete_images: {})
    end

    def listing_tag_params
      params.require(:listing).permit(tags: {})
    end

    def search_params
      params.require(:search).permit(:city, :start_date, :end_date)
    end
end

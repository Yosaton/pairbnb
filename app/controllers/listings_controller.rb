class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy, :verify]

  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.all
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    @listing_images = @listing.listing_photos.shuffle
    @random_main_image = @listing_images.pop
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

        # Handle image uploads
        if(listing_photo_params[:photos].length != 0)
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
    max_photos_notice = ""
    # If updating, just add more new photos that are uploaded
    if(listing_photo_params[:photos] != nil)

      listing_photo_params[:photos].each do |photo|
        if(@listing.can_add_more_photos?)
          new_photo = ListingPhoto.new(photo: photo)
          new_photo.listing_id = @listing.id
          new_photo.save
          @listing = Listing.find_by_id(@listing.id) # Need to re-get reference to @listing to update the picture count        else
          max_photos_notice = "However, exceeded maximum photos limit of 8."
        end

      end
    end

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

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:name, :property_type, :address, :city, :country, :price, :capacity, :description)
    end

    def listing_photo_params
      params.require(:listing).permit(photos: [])
    end
end

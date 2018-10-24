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
    @listing = Listing.new(listing_params)
    @listing.user_id = current_user.id
    @listing.save

    # Handle image uploads
    listing_photo_params[:photos].each do |photo|
      new_photo = ListingPhoto.new(photo: photo)
      new_photo.listing_id = @listing.id
      new_photo.save
    end

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
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

    # If updating, just add more new photos that are uploaded
    if(listing_photo_params[:photos] != nil)
      listing_photo_params[:photos].each do |photo|
        new_photo = ListingPhoto.new(photo: photo)
        new_photo.listing_id = @listing.id
        new_photo.save
      end
    end

    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to listing_path(@listing.id), notice: 'Listing was successfully updated.' }
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

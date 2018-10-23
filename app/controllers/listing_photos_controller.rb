class ListingPhotosController < ApplicationController
  before_action :set_listing_photo, only: [:show, :edit, :update, :destroy]

  # GET /listing_photos
  # GET /listing_photos.json
  def index
    @listing_photos = ListingPhoto.all
  end

  # GET /listing_photos/1
  # GET /listing_photos/1.json
  def show
  end

  # GET /listing_photos/new
  def new
    @listing_photo = ListingPhoto.new
  end

  # GET /listing_photos/1/edit
  def edit
  end

  # POST /listing_photos
  # POST /listing_photos.json
  def create
    @listing_photo = ListingPhoto.new(listing_photo_params)

    respond_to do |format|
      if @listing_photo.save
        format.html { redirect_to @listing_photo, notice: 'Listing photo was successfully created.' }
        format.json { render :show, status: :created, location: @listing_photo }
      else
        format.html { render :new }
        format.json { render json: @listing_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listing_photos/1
  # PATCH/PUT /listing_photos/1.json
  def update
    respond_to do |format|
      if @listing_photo.update(listing_photo_params)
        format.html { redirect_to @listing_photo, notice: 'Listing photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing_photo }
      else
        format.html { render :edit }
        format.json { render json: @listing_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listing_photos/1
  # DELETE /listing_photos/1.json
  def destroy
    @listing_photo.destroy
    respond_to do |format|
      format.html { redirect_to listing_photos_url, notice: 'Listing photo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing_photo
      @listing_photo = ListingPhoto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_photo_params
      params.fetch(:listing_photo, {})
    end
end

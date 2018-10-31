class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:new]

  # GET /bookings
  # GET /bookings.json
  def index
    @user = User.find_by_id(params[:format])
    @bookings = Booking.where(user_id: params[:format])
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @listing = Listing.find_by_id(listing_id_from_params[:listing_id].to_i)
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @listing = Listing.find_by_id(listing_id_from_params[:listing_id].to_i)
    @booking = Booking.new(booking_params)
    @booking.user_id = current_user.id
    @booking.listing_id = @listing.id
    @booking.price = @booking.calculate_total_price(@listing.price)

    respond_to do |format|
      if @booking.save
        BookingJob.perform_later(@booking, "new")
        format.html { redirect_to listing_path(@listing), notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:start_date, :end_date)
    end

    # Get the listing ID this booking is for, based off the params sent in listing#show
    def listing_id_from_params
      params.permit(:listing_id)
    end
end

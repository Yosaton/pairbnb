class BraintreeController < ApplicationController
	before_action :get_booking, only: [:show]
	before_action :require_login, only: [:show]

  	def show
		@client_token = Braintree::ClientToken.generate
  	end

	def checkout
		booking = Booking.find_by_id(params[:checkout_form][:booking_id])
		nonce_from_the_client = params[:checkout_form][:payment_method_nonce]

		result = Braintree::Transaction.sale(
		:amount => booking.c_t_p,
		:payment_method_nonce => nonce_from_the_client,
		:options => {
		:submit_for_settlement => true
		}
		)

		if result.success?
			booking.is_paid = true
			booking.save

			redirect_to booking_path(booking.id), :flash => { :success => "Transaction successful!" }
		else
			redirect_to :root, :flash => { :error => "Transaction failed. Please try again." }
		end
	end

	private

	def get_booking
		@booking = Booking.find_by_id(params[:booking_id])
	end
end
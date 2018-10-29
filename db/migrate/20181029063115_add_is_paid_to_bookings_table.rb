class AddIsPaidToBookingsTable < ActiveRecord::Migration[5.2]
  def change
  	add_column(:bookings, :is_paid, :boolean, default: false)
  end
end

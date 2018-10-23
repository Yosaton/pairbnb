class User < ApplicationRecord
  include Clearance::User


  # Associations
  has_many 	:listings 
  has_many 	:bookings
  has_one 	:avatar

  # Symbols Constant (for ASCII)
  SYMBOLS = {login: "🚪", logout: "⏻"}

  # Functions
  def full_name # Returns full name
  	return "#{first_name} #{last_name}"
  end

end
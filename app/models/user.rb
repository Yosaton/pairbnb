class User < ApplicationRecord
  include Clearance::User

  # Enum for roles
  enum role: [:customer, :moderator, :superadmin]

  # Associations
  has_many :authentications, dependent: :destroy #omniauth
  has_many 	:listings 
  has_many 	:bookings
  has_one 	:avatar

  # Symbols Constant (for ASCII)
  SYMBOLS = {login: "🚪", logout: "⏻"}

  # Functions
  def full_name # Returns full name
  	return "#{first_name} #{last_name}"
  end


  #Omniauth Functions
  def self.create_with_auth_and_hash(authentication, auth_hash)
    first_name = auth_hash["info"]["name"].split(" ").first
    last_name = auth_hash["info"]["name"].split(" ").last
    user = self.create!(
    first_name: first_name,
    last_name: last_name,
    email: auth_hash["info"]["email"],
    password: SecureRandom.hex(10)
    )
    user.authentications << authentication
    return user
  end

  # grab google to access google for user data
  def google_token
    x = self.authentications.find_by(provider: 'google_oauth2')
    return x.token unless x.nil?
    
  end

end
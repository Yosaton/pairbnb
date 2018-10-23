# Seed Users
user = {}
user['password'] = 'asdf'

ActiveRecord::Base.transaction do
  25.times do 
    user['first_name'] = Faker::Name.first_name 
    user['last_name'] = Faker::Name.last_name
    user['birthdate'] = Faker::Date.between(50.years.ago, Date.today)
    user['email'] = Faker::Internet.email
    User.create(user)
  end
end 

# Seed Listings
listing = {}
uids = []
User.all.each { |u| uids << u.id }

ActiveRecord::Base.transaction do
  100.times do 
    listing['name'] = Faker::App.name
    listing['property_type'] = ["House", "Entire Floor", "Condominium", "Villa", "Townhouse", "Castle", "Treehouse", "Igloo", "Yurt", "Cave", "Chalet", "Hut", "Tent", "Other"].sample
    listing['address'] = Faker::Address.street_address
    listing['city'] = Faker::Address.city
    listing['country'] = Faker::Address.country
    listing['price'] = 1 + rand(10000)
    listing['capacity'] = 1 + rand(10)
    listing['price'] = rand(80..500)
    listing['description'] = Faker::Hipster.sentence
    listing['user_id'] = uids.sample

    Listing.create(listing)
  end
end

# Make test accounts
# Fake customer
user = {}

user['first_name'] = "Test"
user['last_name'] = "Customer"
user['birthdate'] = Faker::Date.between(50.years.ago, Date.today)
user['email'] = "customer@test.com"
user['password'] = "1234567890"
User.create(user)

# Fake moderator
user = {}

user['first_name'] = "Test"
user['last_name'] = "Moderator"
user['birthdate'] = Faker::Date.between(50.years.ago, Date.today)
user['email'] = "moderator@test.com"
user['password'] = "1234567890"
User.create(user)

# Fake superadmin
user = {}

user['first_name'] = "Test"
user['last_name'] = "Superadmin"
user['birthdate'] = Faker::Date.between(50.years.ago, Date.today)
user['email'] = "superadmin@test.com"
user['password'] = "1234567890"
User.create(user)
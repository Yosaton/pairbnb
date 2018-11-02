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
property_types = ["House", "Entire Floor", "Condominium", "Villa", "Townhouse", "Castle", "Treehouse", "Igloo", "Yurt", "Cave", "Chalet", "Hut", "Tent", "Other"]
random_bool = [true, false]
random_tags = []

50.times do
    random_tags << Faker::Hacker.adjective
end 

random_tags.uniq.each do |tag|
    Tag.create(text: tag)
end

listing = {}
uids = []
User.all.each { |u| uids << u.id }

ActiveRecord::Base.transaction do
  100.times do 
    listing['name'] = Faker::App.name
    listing['property_type'] = property_types.sample
    listing['address'] = Faker::Address.street_address
    listing['city'] = Faker::Address.city
    listing['country'] = Faker::Address.country
    listing['price'] = 49 + rand(10000)
    listing['capacity'] = 1 + rand(10)
    listing['rating'] = rand(0..5)
    listing['description'] = Faker::Hipster.paragraph(4, true, 4)
    listing['is_verified'] = random_bool.sample
    listing['user_id'] = uids.sample

    listing['n_bedrooms'] = 1 + rand(7)
    listing['n_bathrooms'] = 1 + rand(7)

    listing['smoking_allowed'] = random_bool.sample

    listing['has_essentials'] = random_bool.sample
    listing['has_airconditioner'] = random_bool.sample 
    listing['has_washer_dryer'] = random_bool.sample 
    listing['has_television'] = random_bool.sample 
    listing['has_fireplace'] = random_bool.sample 
    listing['has_wifi'] = random_bool.sample 
    listing['has_hot_water'] = random_bool.sample 
    listing['has_kitchen'] = random_bool.sample 
    listing['has_heating'] = random_bool.sample 
    listing['has_living_room'] = random_bool.sample 

    new_listing = Listing.new(listing)
    new_listing.save

    3.times do 
        Tagging.create(listing_id: new_listing.id, tag_id: Tag.all.sample.id)
    end
  end
end

# Seed bookings
all_users = User.all 
all_listings = Listing.all

all_listings.each do |listing|

    (2+rand(8)).times do 

        start_date = Faker::Date.between(Date.today, 1.year.from_now)
        end_date = start_date + rand(50).days

        new_booking = Booking.create(user_id: all_users.sample.id, listing_id: listing.id, start_date: start_date, end_date: end_date, price: (listing.price*(end_date-start_date)), is_paid: random_bool.sample)
        
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
user['role'] = 0
User.create(user)

# Fake moderator
user = {}

user['first_name'] = "Test"
user['last_name'] = "Moderator"
user['birthdate'] = Faker::Date.between(50.years.ago, Date.today)
user['email'] = "moderator@test.com"
user['password'] = "1234567890"
user['role'] = 1
User.create(user)

# Fake superadmin
user = {}

user['first_name'] = "Test"
user['last_name'] = "Superadmin"
user['birthdate'] = Faker::Date.between(50.years.ago, Date.today)
user['email'] = "superadmin@test.com"
user['password'] = "1234567890"
user['role'] = 2
User.create(user)
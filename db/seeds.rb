puts 'Adding Leia Organa'
User.create!(name: 'Leia Organa',
             email: 'leia@rebelalliance.org',
             password: 'password',
             password_confirmation: 'password',
             verified: true,
             verified_at: Time.zone.now)

puts 'Adding Darth Vader'
User.create!(name: 'Darth Vader',
             email: 'darth_vader@galacticempire.gov',
             password: 'password',
             password_confirmation: 'password',
             verified: true,
             verified_at: Time.zone.now,
             admin: true)

puts 'Adding Barack Obama'
User.create!(name: 'Barack Obama',
             email: 'potus@not.us.gov',
             password: 'password',
             password_confirmation: 'password',
             verified: false)

96.times do |n|
  name = Faker::Name.name
  puts "Adding #{name}"
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               verified: true,
               verified_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
puts "Adding posts for #{users.map(&:name).join ', '}"
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

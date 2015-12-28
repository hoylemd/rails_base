puts 'Adding Leia Organa'
User.create!(name: 'Leia Organa',
             email: 'leia@rebelalliance.org',
             password: 'password',
             password_confirmation: 'password',
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  puts "Adding #{name}"
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

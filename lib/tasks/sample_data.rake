namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    user = User.create!(name: "Example User", 
                        email: 'foo@example.com', 
                        password: 'foobar', 
                        password_confirmation: 'foobar')
    user.toggle!(:admin)
    
    99.times do |n|
      name     = Faker::Name.name
      email    = "example-#{n+1}@example.com"
      password = "password"
      
      User.create!(name: name, 
                   email: email, 
                   password: password, 
                   password_confirmation: password)
    end

    users = User.all(limit: 5)
    50.times do 
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content )}
    end
  end
end

User.create!(name: "Sample User",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password")
             
20.times do |n|
  name  = Gimei.kanji 
  email = "sample#{n+6}@example.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
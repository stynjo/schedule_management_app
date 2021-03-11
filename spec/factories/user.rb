FactoryBot.define do 
  factory :user do 
    name {"test"}
    email {'test2@rspec.com'}
    password {"password"}
    password_confirmation {"password"}
  end 
end 
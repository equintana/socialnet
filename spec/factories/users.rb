# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
  	name "ricardo"
  	password "password123"
  	sequence(:email) {|n| "person#{n}@example.com" }
  end
end

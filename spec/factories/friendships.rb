# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :friendship do
    association :user, factory: :user
    association :friend, factory: :user
  end
end

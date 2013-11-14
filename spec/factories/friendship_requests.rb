# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :friendship_request do
    association :receiver_user, factory: :user
    association :sender_user, factory: :user
    status "pending"
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :friendship_request do
    receiver_friend_id 1
    sender_user_id 2
    status "pending"
  end
end

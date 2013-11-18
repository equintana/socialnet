FactoryGirl.define do
  factory :friendship_request do
    association :receiver_user, factory: :user
    association :sender_user, factory: :user
    # receiver_user_id 1
    # sender_user_id nil  # it should be always the current_user 
    status "pending"
  end
end

FactoryGirl.define do
  factory :message do
    sequence(:body) { |n| "message_#{n}" }
    username "testuser"
    user_id 1
    room_id 1
  end
end

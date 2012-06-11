FactoryGirl.define do
  factory :message do
    sequence(:body) { |n| "message_#{n}" }
    sequence(:sid) { |n| "#{n}" }
    sequence(:room_id)
  end
end

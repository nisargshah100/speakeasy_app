FactoryGirl.define do
  factory :destroyed_room do
    sequence(:destroyed_at) { |n| DateTime.now - n }
    sequence(:sid) { |n| "#{n}" }
    sequence(:room_id) { |n| "#{n}" }
  end
end

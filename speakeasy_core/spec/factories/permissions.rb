FactoryGirl.define do
  factory :permission do
    sequence(:sid)
    sequence(:room_id)
  end
end

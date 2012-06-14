FactoryGirl.define do
  factory :created_user do
    sequence(:created_at) { |n| DateTime.now - n }
    sequence(:sid) { |n| "sid_#{n}" }
  end
end

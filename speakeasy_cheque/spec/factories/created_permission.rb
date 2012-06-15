FactoryGirl.define do
  factory :created_permission do
    sequence(:created_at) { |n| DateTime.now - n }
    sequence(:sid) { |n| "#{n}" }
  end
end

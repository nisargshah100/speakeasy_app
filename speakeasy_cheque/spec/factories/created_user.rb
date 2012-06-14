FactoryGirl.define do
  factory :created_user do
    sequence(:created_at) { |n| DateTime.now - n }
    sequence(:sid) { |n| "sid_#{n}" }
    sequence(:name) { |n| "name_#{n}" }
    sequence(:email) { |n| "email_#{n}@gmail.com" }
  end
end

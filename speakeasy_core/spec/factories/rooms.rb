FactoryGirl.define do
  factory :room, :aliases => [:empty_room] do
    sequence(:name) { |n| "room_#{n}" }
    description "Goings on"
    sequence(:sid) { |n| "#{n}" }
  end

  factory :room_with_messages, parent: :room do
    after_create do |room, evaluator|
      3.times do
        FactoryGirl.create(:message, room: room)
      end
    end
  end

  factory :room_with_many_messages, parent: :room do
    after_create do |room, evaluator|
      55.times do
        FactoryGirl.create(:message, room: room)
      end
    end
  end
end

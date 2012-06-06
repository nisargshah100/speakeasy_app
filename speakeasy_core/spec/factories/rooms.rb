FactoryGirl.define do
  factory :room, :aliases => [:empty_room] do
    sequence(:name) { |n| "room_#{n}" }
    description "Goings on"
  end

  factory :room_with_messages, parent: :room do
    after_create do |room, evaluator|
      3.times do
        FactoryGirl.create(:message, room: room)
      end
    end
  end
end

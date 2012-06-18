require 'spec_helper'

describe CreatedMessage, redis: true do
  describe "#create_from_on_tap" do
    let!(:room) { FactoryGirl.create(:created_room) }
    let(:data) { {"sid" => "SID",
                  "room_id" => room.room_id,
                  "created_at" => DateTime.now.to_s} }

    it "creates a new created_message record" do
      expect{
        CreatedMessage.create_from_on_tap(data) 
        }.to change{CreatedMessage.count}.by(1)
    end

    it "increases the aggregate messages count by 1" do
      previous_message_count = Aggregate.messages.to_i
      CreatedMessage.create_from_on_tap(data)
      Aggregate.messages.to_i.should == previous_message_count + 1
    end
  end
end

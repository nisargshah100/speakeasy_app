require 'spec_helper'

describe CreatedRoom, redis: true do
  describe "#create_from_on_tap" do
    let(:data) { {"sid" => "SID", "room_id" => "1", "created_at" => DateTime.now.to_s} }

    it "creates a new created_room record" do
      expect{ CreatedRoom.create_from_on_tap(data) }.to change{CreatedRoom.count}.by(1)
    end

    it "increases the aggregate rooms count by 1" do
      previous_room_count = Aggregate.rooms.to_i
      CreatedRoom.create_from_on_tap(data)
      Aggregate.rooms.to_i.should == previous_room_count + 1
    end
  end
end

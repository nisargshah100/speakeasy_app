require 'spec_helper'

describe DestroyedRoom do
  describe "#create_from_on_tap" do
    let(:data) { {"sid" => "SID", "room_id" => "1", "destroyed_at" => DateTime.now.to_s} }

    it "creates a new destroyed_room record" do
      expect{ DestroyedRoom.create_from_on_tap(data) }.to change{DestroyedRoom.count}.by(1)
    end

    it "decreases the aggregate rooms count by 1" do
      previous_room_count = Aggregate.rooms.to_i
      DestroyedRoom.create_from_on_tap(data)
      Aggregate.rooms.to_i.should == previous_room_count - 1
    end
  end
end

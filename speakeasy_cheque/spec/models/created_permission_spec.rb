require 'spec_helper'

describe CreatedPermission, redis: true do
  describe "#create_from_on_tap" do
    let!(:room) { FactoryGirl.create(:created_room) }
    let(:data) { {"sid" => "SID", "room_id" => room.room_id, "created_at" => DateTime.now.to_s} }

    it "creates a new created_permission record" do
      expect{ CreatedPermission.create_from_on_tap(data) }.to change{CreatedPermission.count}.by(1)
    end

    it "increases the aggregate permissions count by 1" do
      previous_permission_count = Aggregate.permissions.to_i
      CreatedPermission.create_from_on_tap(data)
      Aggregate.permissions.to_i.should == previous_permission_count + 1
    end
  end
end

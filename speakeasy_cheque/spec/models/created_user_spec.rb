require 'spec_helper'

describe CreatedUser do
  describe "#create_from_on_tap" do
    let(:data) { {"sid" => "SID", "created_at" => DateTime.now.to_s} }

    it "creates a new created_user record" do
      expect{ CreatedUser.create_from_on_tap(data) }.to change{CreatedUser.count}.by(1)
    end

    it "increases the aggregate users count by 1" do
      previous_user_count = Aggregate.users.to_i
      CreatedUser.create_from_on_tap(data)
      Aggregate.users.to_i.should == previous_user_count + 1
    end
  end
end

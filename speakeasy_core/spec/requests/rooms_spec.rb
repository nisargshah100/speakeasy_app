require 'spec_helper'

describe "Rooms" do
  let!(:room) { FactoryGirl.create(:room) }

  describe "#index" do
    before(:each) { get rooms_url(:format => :json) }
    it "returns a successful json response of all rooms" do
      response_room = JSON.parse(response.body).first
      response_room.values.should include(room.name)
      response_room.values.should include(room.description)
    end

    it "returns a 200 response" do
      response.status.should == 200
    end
  end

  describe "#create" do
    let!(:room_count) { Room.count }
    before(:each) { post rooms_url(:format => :json), params }
    context "with a complete, valid request body" do
      let(:params) { {:room => {name: "Hungry Academy", description: "Boom"}} }
      it "creates a room" do
        Room.last.name.should == "Hungry Academy"
        Room.last.description.should == "Boom"
        Room.count.should == room_count + 1
      end

      it "returns a 201 response" do
        response.status.should == 201
      end
    end
    context "with a partial, valid request body" do
      let!(:params) { {:room => {name: "Hungry Academy"}} }
      it "creates a room with a 201 response" do
        Room.last.name.should == "Hungry Academy"
        Room.last.description.should be_nil
        Room.count.should == room_count + 1
      end

      it "returns a 201 response" do
        response.status.should == 201
      end
    end
    context "without a valid request body" do
      let!(:params) { {} }
      it "does not create a room" do
        Room.count.should == room_count
      end

      it "returns a 400 response" do
        response.status.should == 400
      end
    end
  end

  describe "#update" do
    before(:each) { put room_url(room.id), params }

    context "with an existing room id" do
      let!(:room) { FactoryGirl.create(:room) }

      context "with full valid request body" do
        let!(:params) { {:room => {name: "Hungry", description: "Academy"}} }
        it "should update the room information" do
          Room.find(room.id).name.should == "Hungry"
          Room.find(room.id).description.should == "Academy"
        end
        it "should return a 200 response" do
          response.status.should == 200
        end
      end

      context "with a partial valid request body" do
        let!(:params) { {:room => {name: "Hungry"}} }

        it "should update only the provided room information" do
          Room.find(room.id).name.should == "Hungry"
          Room.find(room.id).description.should_not be_nil
        end
        it "should return a 200 response" do
          response.status.should == 200
        end
      end

      context "with an invalid request body" do
        let!(:params) { {:room => {name: ""}} }

        it "should not update the room information" do
          Room.find(room.id).name.should_not == "Hungry"
        end

        it "should return a 400 response" do
          response.status.should == 400
        end
      end
    end
    context "with a non-existent room id" do
      let!(:room) { double(:id => 9999)}
      let!(:params) { {:room => {name: "Hungry"}} }

      it "returns a 404 error" do
        response.status.should == 404
      end
    end
  end

  describe "#destroy" do
    let!(:room) { FactoryGirl.create(:room) }
    before(:each) { delete room_path(room) }
    context "with an existing room id" do
      it "destroys the room" do
        Room.find_by_id(room.id).should be_nil
      end

      it "returns a 200 status" do
        response.status.should == 200
      end
    end
    context "with a non-existent room id" do
      let!(:room) { double(:id => 9999) }

      it "returns a 400 error" do
        response.status.should == 400
      end
    end
  end
end

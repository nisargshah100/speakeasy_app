  require 'spec_helper'

  describe "Rooms" do
    let!(:room) { FactoryGirl.create(:room) }

    describe "#index" do
      context "the request has a valid token" do
        let!(:other_room) { FactoryGirl.create(:room) }
        let!(:someone_elses_room) { FactoryGirl.create(:room) }
        let!(:permission) { FactoryGirl.create(:permission, room_id: room.id, sid: "SID") }
        let!(:other_permission) { FactoryGirl.create(:permission, room_id: other_room.id, sid: "SID") }

        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: "SID"))
          get rooms_url(:format => :json)
        end
        it "returns a successful json response of all rooms the token user has access to" do
          response_json = JSON.parse(response.body)
          response_json.any? { |room_hash| room_hash.value?(room.name) }.should be_true
          response_json.any? { |room_hash| room_hash.value?(other_room.name) }.should be_true
        end

        it "does not return rooms the token user does not have access to" do
          response_json = JSON.parse(response.body)
          response_json.any? { |room_hash| room_hash.value?(someone_elses_room.name) }.should be_false
        end
        it "returns a 200 response" do
          response.status.should == 200
        end
      end

      context "the request does not have a valid token" do
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(nil)
          get rooms_url(:format => :json)
        end

        it "returns a 401 response" do
          response.status.should == 401
        end
      end
    end

    describe "#create" do
      let!(:room_count) { Room.count }
      let!(:permission_count) { Permission.count }
      context "the request has a valid token" do
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: room.sid))
          post rooms_url(:format => :json), params
        end
        context "with a complete, valid request body" do
          let(:params) { {:room => {name: "Hungry Academy", description: "Boom"}} }
          it "creates a room" do
            Room.last.name.should == "Hungry Academy"
            Room.last.description.should == "Boom"
            Room.count.should == room_count + 1
          end

          it "creates a new permission" do
            Permission.count.should == permission_count + 1
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

      context "the request does not have a valid token" do
        let(:params) { {} }
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(nil)
          post rooms_url(:format => :json), params
        end
        it "returns a 401 response" do
          response.status.should == 401
        end
      end
    end

    describe "#update" do
      context "the request has a valid token" do
        context "with an existing room id" do
          let!(:room) { FactoryGirl.create(:room) }

          context "the token user is the room owner" do
            before(:each) do
              SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: room.sid))
              put room_url(room.id), params
            end

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

          context "the token user is not the room owner" do
            let(:params) { {} }
            before(:each) do
              SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: "WRONG"))
              put room_url(room.id), params
            end

            it "returns a 401 response" do
              response.status.should == 401
            end
          end
        end

        context "with a non-existent room id" do
          before(:each) do
            SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double)
            put room_url(room.id), params
          end
          let!(:room) { double(id: 9999) }
          let!(:params) { {:room => {name: "Hungry"}} }

          it "returns a 404 error" do
            response.status.should == 404
          end
        end
      end

      context "the request does not have a valid token" do
        let!(:params) { {} }
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(nil)
          put room_url(room.id), params
        end

        it "returns a 401 response" do
          response.status.should == 401
        end
      end
    end

    describe "#destroy" do
      let!(:room) { FactoryGirl.create(:room) }
      context "the request has a valid token" do
        context "with an existing room id" do
          context "the token user is the room's owner" do
            before(:each) do
              SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: room.sid))
              delete room_path(room)
            end
            it "destroys the room's permissions" do
              Room.find_by_id(room.id).permissions.count.should be(0)
            end

            it "returns a 200 status" do
              response.status.should == 200
            end
          end
        end

        context "the token user is not the room's owner" do
          before(:each) do
            SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: "WRONG"))
            delete room_path(room)
          end

          it "returns a 401 response" do
            response.status.should == 401
          end
        end
      end
      context "with a non-existent room id" do
        let!(:room) { { :id => 9999 } }
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double)
          delete room_path(room)
        end

        it "returns a 404 error" do
          response.status.should == 404
        end
      end

      context "the request does not have a valid token" do
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(nil)
          delete room_path(room)
        end

        it "returns a 401 response" do
          response.status.should == 401
        end
      end
    end
  end

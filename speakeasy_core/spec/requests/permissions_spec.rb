require 'spec_helper'
require 'ostruct'

describe PermissionsController do
  let!(:room) { FactoryGirl.create(:room) }
  let!(:permission) { FactoryGirl.create(:permission, room_id: room.id) }
  let!(:permissions_count) { Permission.count }

  before(:each) do
    SpeakeasyBouncerGem.stub(:get_user_by_email).and_return(double(sid: "AX798"))
  end

  describe "#create" do
    let(:params) { {email: 'fake@fake.com', permission: { room_id: room.id }} }
  
    context "with a valid token" do
      context "the token user is the room owner" do
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: room.sid))
        end

        context "with a valid sid" do
          it "creates a new room permission" do
            expect { post room_permissions_path(room, format: :json), params }.to change { Permission.count }.by(1)
            Permission.last.room_id.should == room.id            
          end

          it "sets the SID on the new permission" do
            post room_permissions_path(room, format: :json), params
            Permission.last.sid.should == "AX798"
          end

          it "returns a 201 created response" do
            post room_permissions_path(room, format: :json), params
            response.status.should == 201
          end
        end
      end

      context "the token user is not the room owner" do
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: "999"))
          post room_permissions_path(room, format: :json), params
        end
        it "does not create a new room permission" do
          Permission.count.should == permissions_count
        end

        it "returns a 401 unauthorized response" do
          response.status.should == 401
        end
      end

      context "the room does not exist" do
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: "999"))
          post room_permissions_path(double, format: :json), params
        end
        it "returns a 404 bad request response" do
          response.status.should == 404
        end
      end
    end

    context "without a valid token" do
      before(:each) do
        SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(nil)
        post room_permissions_path(room, format: :json), params
      end
      it "does not create a new room permission" do
        Permission.count.should == permissions_count
      end

      it "returns a 401 unauthorized response" do
        response.status.should == 401
      end
    end
  end

  describe "#destroy" do
    context "with a valid token" do
      context "the token user is the room owner" do
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: room.sid))
          FactoryGirl.create(:permission, sid: "AX798", room_id: room.id)          
        end

        def delete_permission
          delete room_permission_path(room, permission, format: :json)
        end

        it "destroys the room permission" do
          expect {delete_permission}.to change {Permission.count}.by(-1)
          #Permission.count.should == permissions_count - 1
        end

        it "returns a 200 OK response" do
          delete_permission
          response.status.should == 200
        end
      end

      context "the token user is not the room owner" do
        before(:each) do
          SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(double(sid: "99999"))
          delete room_permission_path(room, permission, format: :json)
        end

        it "does not destroy the room permission" do
          Permission.count.should == permissions_count
        end

        it "returns a 401 unauthorized response" do
          response.status.should == 401
        end
      end

      context "the room does not exist" do
        before(:each) do
          delete '/api/core/rooms/99/permissions/99'
        end

        it "returns a 404 bad request response" do
          response.status.should == 404
        end
      end

      context "the permission does not belong to the room" do
        before(:each) do
          delete "api/core/rooms/99/permissions/#{permission.id}"
        end

        it "returns a 404 bad request response" do
          response.status.should == 404
        end
      end
    end

    context "without a valid token" do
      before(:each) do
        SpeakeasyBouncerGem.stub(:get_user).with(nil).and_return(nil)
        delete room_permission_path(room, permission, format: :json)
      end

      it "does not destroy the room permission" do
        Permission.count.should == permissions_count
      end

      it "returns a 401 unauthorized response" do
        response.status.should == 401
      end
    end
  end
end

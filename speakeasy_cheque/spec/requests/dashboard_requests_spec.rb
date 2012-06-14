require 'spec_helper'

describe "Dashboard" do
  context "#show" do
    before(:all) do
      FactoryGirl.create_list(:created_message, 10)
      FactoryGirl.create_list(:created_room, 5)
      FactoryGirl.create_list(:destroyed_room, 2)
      FactoryGirl.create_list(:created_user, 8)
    end

    after(:all) do
      CreatedMessage.destroy_all
      CreatedRoom.destroy_all
      DestroyedRoom.destroy_all
      CreatedUser.destroy_all
    end

    before(:each) do
      visit dashboard_path
    end

    it "displays the total number of current messages" do
      page.should have_content("10 Messages")
    end

    it "displays the total number of current rooms" do
      page.should have_content("3 Rooms")
    end

    it "displays the total number of current rooms" do
      page.should have_content("8 Users")
    end
  end
end

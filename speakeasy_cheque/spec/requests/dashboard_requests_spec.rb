require 'spec_helper'

describe "Dashboard", redis: true do
  context "#show" do
    before(:each) do
      FactoryGirl.create_list(:created_room, 3)
      FactoryGirl.create_list(:created_message, 30)
      FactoryGirl.create_list(:created_user, 5)
    end

    context "the user is an admin" do
      before(:each) do
        SpeakeasyBouncerGem.stub(:user_is_admin?).and_return(true)
        visit dashboard_path
      end

      it "displays the total number of current messages" do
        page.should have_content("30 Messages")
      end

      it "displays the total number of current rooms" do
        page.should have_content("3 Rooms")
      end

      it "displays the total number of current rooms" do
        page.should have_content("5 Users")
      end
    end

    context "the user is not an admin" do
      before(:each) do
        SpeakeasyBouncerGem.stub(:user_is_admin?).and_return(false)
        visit dashboard_path
      end

      it "returns a tells the user that they are unauthorized" do
        page.should have_content("Looks like you're not on the list.")
      end
    end

  end
end

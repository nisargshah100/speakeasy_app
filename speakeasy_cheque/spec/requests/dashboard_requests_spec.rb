require 'spec_helper'

describe "Dashboard" do
  context "#show" do
    before(:all) do
      # Build 10 messages with a factory
      10.times do
        CreatedMessage.create
      end
    end

    after(:all) do
      # Destroy those 10 messages
      CreatedMessage.destroy_all
    end

    it "exists" do
      visit dashboard_path
    end

    it "displays the total number of created messages" do
      within("#created_messages") do
        page.should have_content("10")
      end
    end
  end
end
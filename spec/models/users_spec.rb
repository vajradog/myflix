require 'rails_helper'

describe User do 
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:queue_items).order("position") } 
  it { should have_many(:reviews) }

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be true
    end

    it "returns false when the user has not queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:user)
      expect(user.queued_video?(video)).to be false
    end
  end
end
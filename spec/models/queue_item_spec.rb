require 'rails_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

  describe "#video_title" do
    it "returns the title of the video" do
      video = Fabricate(:video, title: "Rambo")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("Rambo")
    end
  end

  describe "#category_name" do 
    it "returns the category name of the video" do
      category = Fabricate(:category, name: "Drama")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("Drama")
    end
  end

  describe "#category" do 
    it "returns the category name of the video" do
      category = Fabricate(:category, name: "Drama")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end

  describe "#rating" do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

    it "returns the rating from the review of the video when present" do
      review = Fabricate(:review, user: user, video: video, rating: 2)
      expect(queue_item.rating).to eq(2)
    end

    it "returns nil when review is not present" do
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#rating=" do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    let(:queue_item) { Fabricate(:queue_item, video: video, user: user) }

    it "changes the rating of the review if review is present" do 
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item.rating = 4
      expect(queue_item.rating).to eq(4)
    end

    it "clears the rating of the review if review present" do 
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end

    it "creates review with the rating if the review is not present" do
      queue_item.rating = 2
      expect(Review.first.rating).to eq(2)
    end
  end
end

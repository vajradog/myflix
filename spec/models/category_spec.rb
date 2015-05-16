require 'rails_helper'

describe Category do 
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe ".recent_videos" do 

    let(:drama) { Category.create(name: "Drama") }
    let(:subject) { drama.recent_videos }

    it "shows only 6 videos if more than 6 videos exists in a category" do 
      Fabricate.times(7, :video, category_id: drama.id)
      expect(subject.count).to eq(6)
    end

    it "shows all videos if less than 6 videos exists in a category" do
      Fabricate.times(4, :video, category_id: drama.id)
      expect(subject.count).to eq(drama.videos.count)
    end

    it "shows all videos order by created_at" do 
      west_wing = Fabricate(:video, title:"West Wing", category_id: drama.id, created_at: 2.days.ago)
      breaking_bad = Fabricate(:video, title: "Breaking Bad", category_id: drama.id)
      expect(subject).to eq([breaking_bad, west_wing])
    end
  end
end

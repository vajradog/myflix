require 'rails_helper'

describe Category do 
  it { should have_many(:videos)}
  it { should validate_presence_of(:name)}

  describe "recent videos" do 
    before do 
      @drama = Category.create(name: "Drama")
    end 
    let(:subject) { @drama.recent_videos }

    it "should show only 6 videos if more than 6 videos exists in a category" do 
      7.times do 
        Fabricate(:video, category_id: @drama.id)
      end
      expect(subject.count).to eq(6)
    end

    it "should show all videos if less than 6 videos exists in a category" do
      4.times do 
        Fabricate(:video, category_id: @drama.id)
      end
      expect(subject.count).to eq(@drama.videos.count)
    end

    it "should show all videos order by created_at" do 
      west_wing = Fabricate(:video, title:"West Wing", category_id: @drama.id, created_at: 2.days.ago)
      breaking_bad = Fabricate(:video, title: "Breaking Bad", category_id: @drama.id)
      expect(subject).to eq([breaking_bad, west_wing])
    end
  end
end

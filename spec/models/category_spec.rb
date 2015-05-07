require 'rails_helper'

describe Category do 
	it { should have_many(:videos)}
	it { should validate_presence_of(:name)}

	describe "recent videos" do 
		it "should show only 6 videos if more than 6 videos exists in a category" do 
			thriller = Category.create(name: "thriller")
			7.times do 
				video = Video.create(title:"24", description: "Fast thriller", category_id: thriller.id)
			end
			expect(thriller.recent_videos.count).to be(6)
		end

		it "should show all videos if less than 6 videos exists in a category" do
		  comedy = Category.create(name: "comedy")
		  4.times do 
		  	video = Video.create(title: "Family Guy", description: "Funny show", category_id: comedy.id)
		  end
		  expect(comedy.recent_videos.count).to eq(comedy.videos.count)
		end

		it "should show all videos order by created_at" do 
			drama = Category.create(name: "comedy")
			west_wing = Video.create(title: "West Wing", description: "Political Thriller", category_id: drama.id, created_at: 1.day.ago)
			breaking_bad = Video.create(title: "Breaking Bad", description: "Political Thriller", category_id: drama.id)
		  expect(drama.recent_videos).to eq([breaking_bad, west_wing])

		end
	end
end
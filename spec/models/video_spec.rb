require 'rails_helper'

describe Video do
	it "saves the video" do 
		video = Video.new(title: "Spirited Away", description: "animated feature",
			small_cover_url: "/tmp/spirited_away.jpg", large_cover_url: "/tmp/spirited_away_large.jpg")
		video.save
		expect(Video.first).to eq(video)
	end

	it "cannot save without the title" do 
		video = Video.new(title: "", description: "animated feature",
			small_cover_url: "/tmp/spirited_away.jpg", large_cover_url: "/tmp/spirited_away_large.jpg")
		video.save
		expect(video).to be_invalid
	end

	it "cannot save without the description" do 
		video = Video.new(title: "Fly away", description: "",
			small_cover_url: "/tmp/spirited_away.jpg", large_cover_url: "/tmp/spirited_away_large.jpg")
		video.save
		expect(video).to be_invalid
	end

	it "belongs to a category" do 
		comedy = Category.create(name: "Comedy")
		family_guy = Video.create(title:"Family Guy", category: comedy)
		expect(family_guy.category).to eq(comedy)
	end
end
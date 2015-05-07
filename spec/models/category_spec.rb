require 'rails_helper'

describe Category do 
	it "saves itself" do 
		category = Category.new(name: "Drama")
		category.save
		expect(Category.first).to eq(category)
	end

	it "has many videos" do 
		drama = Category.create(name: "drama")
		breaking_bad = Video.create(title: "Breaking Bad", description: "animated feature",
			small_cover_url: "/tmp/spirited_away.jpg", large_cover_url: "/tmp/spirited_away_large.jpg", category: drama)
		walking_dead = Video.create(title: "Walking Dead", description: "animated feature",
			small_cover_url: "/tmp/spirited_away.jpg", large_cover_url: "/tmp/spirited_away_large.jpg", category: drama)
		expect(drama.videos).to eq([breaking_bad, walking_dead])
	end
end
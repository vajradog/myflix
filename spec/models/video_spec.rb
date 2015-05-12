require 'rails_helper'

describe Video do
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
  it { should have_many(:reviews).order("created_at DESC")}
  it { should have_many(:queue_items) }

  describe ".search_by_title" do 
    before do 
      @totoro = Fabricate(:video, title: "totoro")
      @ponyo = Fabricate(:video, title: "Ponyo", created_at: 1.day.ago)
    end

    it "returns empty array when match not found" do 
      expect(Video.search_by_title("Whatever")).to eq([])
    end

    it "returns an array of one video when one match found" do 
      expect(Video.search_by_title("Totoro")).to eq([@totoro])
    end

    it "returns an array of one video when partial match found" do 
      expect(Video.search_by_title("Tot")).to eq([@totoro])
    end

    it "returns an array of one video when mixed case found" do 
      expect(Video.search_by_title("tOTorO")).to eq([@totoro])
    end

    it "returns an array of all matches ordered by created_at when multiple matches found" do 
      tot = Fabricate(:video, title: "Tot")
      expect(Video.search_by_title("Tot")).to eq([tot, @totoro])
    end

    it "returns an empty array search term is empty string" do 
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
require 'rails_helper'

describe Video do
  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}

  describe "search by title" do 
    it "returns empty array when match not found" do 
      totoro = Video.create(title:"Totoro", description:"cool animation")
      ponyo = Video.create(title:"Ponyo", description:"another cool animation")
      expect(Video.search_by_title("Family")).to eq([])
    end

    it "returns an array of one video when one match found" do 
      totoro = Video.create(title:"Totoro", description:"cool animation")
      ponyo = Video.create(title:"Ponyo", description:"another cool animation")
      expect(Video.search_by_title("Totoro")).to eq([totoro])
    end

    it "returns an array of one video when partial match found" do 
      totoro = Video.create(title:"Totoro", description:"cool animation")
      ponyo = Video.create(title:"Ponyo", description:"another cool animation")
      expect(Video.search_by_title("Tot")).to eq([totoro])
    end

    it "returns an array of one video when mixed case found" do 
      totoro = Video.create(title:"Totoro", description:"cool animation")
      ponyo = Video.create(title:"Ponyo", description:"another cool animation")
      expect(Video.search_by_title("tOTorO")).to eq([totoro])
    end

    it "returns an array of all matches ordered by created_at when multiple matches found" do 
      totoro = Video.create(title:"Totoro", description:"cool animation", created_at: 1.day.ago)
      tot = Video.create(title:"Tot", description:"Childrens animation")
      ponyo = Video.create(title:"Ponyo", description:"another cool animation")
      expect(Video.search_by_title("Tot")).to eq([tot, totoro])
    end

    it "returns an empty array search term is empty string" do 
      tot = Video.create(title:"Tot", description:"Childrens animation")
      ponyo = Video.create(title:"Ponyo", description:"another cool animation")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
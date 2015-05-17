require 'rails_helper'

describe VideosController do
  describe "GET show" do
    before { set_current_user }
    let(:video) { Fabricate(:video) }

    it "sets @video for authenticated user" do 
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for authenticated user" do
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    context "with authenticated user" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :show, id: video.id }
      end
    end
  end

  describe "Get search" do
    before { set_current_user }

    context "when authenticated user, sets @results" do
      it "sets @results for authenticated users" do 
        ponyo = Fabricate(:video, title: "Ponyo")
        get :search, search_term: "ponyo"
        expect(assigns(:results)).to eq([ponyo])
      end

     it "returns empty array when search term is empty" do 
       get :search, search_term: ""
       expect(assigns(:results)).to eq ([])
     end
   end

    context "with unauthenticated user" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :search, search_term: "ponyo" }
      end
    end
  end
end

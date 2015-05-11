require 'rails_helper'

describe VideosController do
  # before { session[:user_id] = Fabricate(:user).id }

  describe "GET show" do 
    it "sets @video for authenticated user" do 
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "redirects to sign_in_path for unauthenticated user" do 
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "Get search" do 
    context "sets @results for authenticated user" do 
      it "sets @results for authenticated users" do 
        session[:user_id] = Fabricate(:user).id
        ponyo = Fabricate(:video, title: "Ponyo")
        get :search, search_term: "ponyo"
        expect(assigns(:results)).to eq([ponyo])
      end

     it "returns empty array when search term is empty" do 
       session[:user_id] = Fabricate(:user).id
       get :search, search_term: ""
       expect(assigns(:results)).to eq ([])
     end
   end

    it "redirects to sign_in_path for unauthenticated user" do
      get :search, search_term: "ponyo"
      expect(response).to redirect_to sign_in_path
    end

  end
end
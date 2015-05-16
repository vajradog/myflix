require 'rails_helper'

describe ReviewsController do
  
  describe 'Post create' do
    let(:video) { Fabricate(:video) }

    context "with authenticated user" do
      
      let(:current_user) { Fabricate(:user)}
      before {session[:user_id] = current_user.id}

      context "with valid inputs" do
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end

        it "redirects to the video show page" do
          expect(response).to redirect_to video
        end

        it "creates a review" do 
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with a video" do 
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with the signed_in user" do
          expect(Review.first.user).to eq(current_user)
        end

        it 'sets the flash notice' do
          expect(flash[:notice]).not_to be_blank
        end
      end

      context "with invalid inputs" do 
        before do
          post :create, review: {rating: 2}, video_id: video.id
        end 

        it "does not create a review" do 
          expect(Review.count).to eq(0)
        end

        it "renders the videos/show template" do
          expect(response).to render_template "videos/show"
        end

        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end

        it "sets @review" do
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 2}, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end

        it 'sets the error message' do
          expect(flash[:error]).not_to be_blank
        end
      end
    end
      
    context "with unauthenticated user" do 
      it "redirects to sign_in path" do
        video = Fabricate(:video)
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end

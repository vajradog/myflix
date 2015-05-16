require 'rails_helper'

describe QueueItemsController do
  
  describe "GET index" do 
    it "sets the @queue_items to the queue items of the signed in user" do\
      thupten = Fabricate(:user)
      session[:user_id] = thupten.id 
      queue_item1 = Fabricate(:queue_item, user: thupten)
      queue_item2 = Fabricate(:queue_item, user: thupten)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects the user to sign in page for unauthenticated user" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do 
    context "with authenticated user" do

      let(:thupten) { Fabricate(:user) }

      before { session[:user_id] = thupten.id }

      it "redirects to my queue page" do 
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "creates a queue_item that is associated with a video" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue_item that is associated with a video" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates the queue_item that is associated with a user" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(thupten)
      end

      it "puts the new queue_item at the bottom of the queue_items list" do
        monk = Fabricate(:video)
        Fabricate(:queue_item, video: monk, user: thupten)
        southpark = Fabricate(:video)
        post :create, video_id: southpark.id
        southpark_queue_item = QueueItem.where(video_id: southpark.id, user_id: thupten.id).first
        expect(southpark_queue_item.position).to eq(2)
      end

      it "does not add the same video twice" do 
        monk = Fabricate(:video)
        Fabricate(:queue_item, video: monk, user: thupten)
        southpark = Fabricate(:video)
        post :create, video_id: monk.id
        southpark_queue_item = QueueItem.where(video_id: southpark.id, user_id: thupten.id).first
        expect(thupten.queue_items.count).to eq(1)
      end
    end

    context "with unauthenticated user" do 
      
      it "redirect to sign in page for unauthenticated user" do
        post :create, video_id: 2
        expect(response).to redirect_to sign_in_path 
      end
    end
  end

  describe "DELETE destroy" do
    context "with authenticated user" do

      let(:thupten) { Fabricate(:user) }

      before { session[:user_id] = thupten.id }

      it "redirects to my queue page" do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
     end

     it "delete the queue item" do 
        queue_item = Fabricate(:queue_item, user: thupten)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
     end

     it "does not delete the queue item if the current user does not own" do
        kevin = Fabricate(:user)
        kevin_queue_item = Fabricate(:queue_item, user: kevin)
        delete :destroy, id: kevin_queue_item.id
        expect(QueueItem.count).to eq(1) 
     end

     it "normalizes the remaining queue_items after destroy" do 
        queue_item1 = Fabricate(:queue_item, user: thupten, position: 1)
        queue_item2 = Fabricate(:queue_item, user: thupten, position: 2)
        delete :destroy, id: queue_item1.id
        expect(QueueItem.first.position).to eq(1)
     end
    end

    context "with unauthenticated user" do
      it "redirects to sign in page for unauthenticated user" do 
        delete :destroy, id: 3
        expect(response).to redirect_to sign_in_path 
      end
    end     
  end

  describe "POST update_queue" do
    context "with valid input" do

      let(:queue_item1) { Fabricate(:queue_item, user: don, video: video, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: don, video: video, position: 2) }
      let (:don) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }

      before { session[:user_id] = don.id }

      it "redirects to my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(don.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalized the position numbers" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(don.queue_items.map(&:position)).to eq([1,2])
      end
    end

    context "with invalid input" do

      let(:don) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: don, video: video, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: don, video: video, position: 2) }
      let(:video) { Fabricate(:video) }

      before {session[:user_id] = don.id}

      it "redirects the the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.3}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end
      it "sets the error notice" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.3}, {id: queue_item2.id, position: 1}]
        expect(flash[:error]).to be_present
      end
      it "does not change the queue items" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1.7}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthorized user" do 
      it "redirects to sign_in path" do 
        post :update_queue, queue_items: [{id: 1, position: 3}, {id: 2, position: 1.7}]
        expect(response).to redirect_to sign_in_path
      end
    end

    context "queue that do not belong to user" do 
      it "does not change the queue items" do
        don = Fabricate(:user)
        alice = Fabricate(:user)
        session[:user_id] = don.id 
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, video: video, position: 1)
        queue_item2 = Fabricate(:queue_item, user: don, video: video, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end


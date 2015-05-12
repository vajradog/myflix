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
      it "redirects to my queue page" do 
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it "creates a queue_item that is associated with a video" do
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue_item that is associated with a video" do
        session[:user_id] = Fabricate(:user).id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates the queue_item that is associated with a user" do
        thupten = Fabricate(:user)
        session[:user_id] = thupten.id
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(thupten)
      end

      it "puts the new queue_item at the bottom of the queue_items list" do
        thupten = Fabricate(:user)
        session[:user_id] = thupten.id 
        monk = Fabricate(:video)
        Fabricate(:queue_item, video: monk, user: thupten)
        southpark = Fabricate(:video)
        post :create, video_id: southpark.id
        southpark_queue_item = QueueItem.where(video_id: southpark.id, user_id: thupten.id).first
        expect(southpark_queue_item.position).to eq(2)
      end

      it "does not add the same video twice" do 
        thupten = Fabricate(:user)
        session[:user_id] = thupten.id 
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

  describe "DELETE destory" do 
    it "should redirect to my queue page" do
      session[:user_id] = Fabricate(:user).id
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
     end
     it "delete the queue item" do 
        thupten = Fabricate(:user)
        session[:user_id] = thupten.id 
        queue_item = Fabricate(:queue_item, user: thupten)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
     end
     it "does not delete the queue item if the current user does not own" do
        thupten = Fabricate(:user)
        kevin = Fabricate(:user)
        session[:user_id] = thupten.id
        kevin_queue_item = Fabricate(:queue_item, user: kevin)
        delete :destroy, id: kevin_queue_item.id
        expect(QueueItem.count).to eq(1) 
     end
     it "redirects to sign in page for unauthenticated user" do 
       delete :destroy, id: 3
       expect(response).to redirect_to sign_in_path 
     end

  end
end

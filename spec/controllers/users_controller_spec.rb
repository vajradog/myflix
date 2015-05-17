require 'rails_helper'

describe UsersController do

  describe "GET new" do 
    it "sets @user" do 
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "Post create" do
    context "with valid data" do 
      before do 
        post :create, user: {email:"sad@y.com", password:"kk", full_name:"ksd"}
      end
      
      it "creates a user" do
        expect(User.count).to eq(1)
      end

      it "signs in the new user" do
        post :create, user: {email:"sad@y.com", password:"kk", full_name:"ksd"}
        expect(session[:user_id]).to_not be_nil 
      end

      it "redirects to home_path after save" do 
        expect(response).to redirect_to home_path
      end
    end
  
    context "with invalid data" do
      before do 
        post :create, user: {email:"sad@y.com", password:"", full_name:"ksd"}
      end

      it "does not create a new user" do 
        expect(User.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template(:new)
      end

      it "sets the @user" do 
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end


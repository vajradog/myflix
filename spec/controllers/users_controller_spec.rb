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
        post :create, user: {email:"sad@y.com", password:"kk", full_name:"John Doe"}
      end
      
      it "creates a user" do
        expect(User.count).to eq(1)
      end

      it "signs in the new user" do
        post :create, user: {email:"sad@y.com", password:"kk", full_name:"John Doe"}
        expect(session[:user_id]).to_not be_nil 
      end

      it "redirects to home_path after save" do 
        expect(response).to redirect_to home_path
      end
    end

    context "send email" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends email to user with valid inputs" do
        post :create, user: {email:"sad@y.com", password:"kk", full_name:"John Doe"}
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it "sends email to the right recipient with valid inputs" do 
        post :create, user: {email:"sad@y.com", password:"kk", full_name:"John Doe"}
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(["sad@y.com"])
      end

      it "sends email with users name with valid inputs" do 
        post :create, user: {email:"sad@y.com", password:"kk", full_name:"John Doe"}
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include("John Doe")
      end

      it "does not send email invalid inputs" do
        post :create, user: {email:"sad@y.com", password:"", full_name:"John Doe"}
        expect(ActionMailer::Base.deliveries).to be_empty
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

  describe "GET show" do
    it_behaves_like "require_sign_in" do 
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      set_current_user
      mary = Fabricate(:user)
      get :show, id: mary.id
      expect(assigns(:user)).to eq(mary)
    end

  end
end


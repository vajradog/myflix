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
        post :create, user: {email:"sad@y.com", password:"password", full_name:"John Doe"}
      end

      it "creates a user" do
        expect(User.count).to eq(1)
      end

      it "signs in the new user" do
        post :create, user: {email:"sad@y.com", password:"password", full_name:"John Doe"}
        expect(session[:user_id]).to_not be_nil
      end

      it "redirects to home_path after save" do
        expect(response).to redirect_to home_path
      end

      it "makes the user(friend) follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, friends_email: "joe@example.com")
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Donald"}, invitation_token: invitation.token
        joe = User.find_by(email: "joe@example.com")
        expect(joe.follows?(alice)).to be true
      end

      it "makes the inviter follow the user(friend)" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, friends_email: "joe@example.com")
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Donald"}, invitation_token: invitation.token
        joe = User.find_by(email: "joe@example.com")
        expect(alice.follows?(joe)).to be true
      end

      it "expires the invitation token expires upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, friends_email: "joe@example.com")
        post :create, user: {email: "joe@example.com", password: "password", full_name: "Joe Donald"}, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end
    end

    context "send email" do
      after { ActionMailer::Base.deliveries.clear }

      it "sends email to user with valid inputs" do
        post :create, user: {email:"sad@y.com", password:"password", full_name:"John Doe"}
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it "sends email to the right recipient with valid inputs" do
        post :create, user: {email:"sad@y.com", password:"password", full_name:"John Doe"}
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(["sad@y.com"])
      end

      it "sends email with users name with valid inputs" do
        post :create, user: {email:"sad@y.com", password:"password", full_name:"John Doe"}
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

  describe "GET new_with_invitation_token" do
    it "sets @user with friends email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.friends_email)
    end

    it "redirects to expired token page for invalid token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: "123"
      expect(response).to redirect_to expired_token_path
    end

    it "sets the @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
  end
end

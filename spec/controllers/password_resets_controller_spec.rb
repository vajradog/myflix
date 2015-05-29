require 'rails_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, '123')
      alice.save
      get :show, id:'123'
      expect(response).to render_template :show
    end

    it "sets @token" do
      alice = Fabricate(:user)
      alice.update_column(:token, '123')
      alice.save
      get :show, id:'123'
      expect(assigns(:token)).to eq('123')
    end

    it "redirects to expired token page if token is invalid" do
      get :show, id: 'wrongtoken123'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do
      it "redirects to the sign in page" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '123')
        post :create, token:'123', password: 'new_password'
        expect(response).to redirect_to sign_in_path
      end

      it "sets the flash success message" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '123')
        post :create, token:'123', password: 'new_password'
        expect(flash[:notice]).to_not be_empty
      end

      it "updates the users password" do
        alice = Fabricate(:user, password: 'old_password')
        alice.update_column(:token, '123')
        post :create, token: '123', password: 'new_password'
        expect(alice.reload.authenticate('new_password')).to eq(alice)
      end

      it "deletes token after password is updated" do
        alice = Fabricate(:user)
        alice.update_column(:token, '123')
        post :create, token: '123', password: 'new_password'
        expect(alice.reload.token).to be_nil
      end
    end

    context "with invalid token" do
      it "redirects to the expired token path" do
        post :create, token: '123', password: 'new_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
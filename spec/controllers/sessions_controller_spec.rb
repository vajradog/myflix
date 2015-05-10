require 'rails_helper'

describe SessionsController do

  describe 'Get new' do
    context 'with authenticated user' do 
      it 'renders the new template' do 
        session[:user_id] = nil
        get :new
        expect(response).to render_template :new
      end
    end
    context 'with unauthenticated user' do
      it 'should redirect to home_path' do 
        session[:user_id] = Fabricate(:user).id
        get :new
        expect(response).to redirect_to home_path
      end
    end
  end

  describe 'Post create' do
    context 'with valid credentials' do
      before do
        @thupten = Fabricate(:user)
        post :create, email: @thupten.email, password: @thupten.password
      end 

      it 'sets sessions[:user_id]' do
        expect(session[:user_id]).to eq(@thupten.id)
      end

      it 'redirects to home_path after successful login' do
        expect(response).to redirect_to home_path
      end

      it 'sets the notice' do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context 'with invalid credentials' do
      before do
        thupten = Fabricate(:user)
        post :create, email: thupten.email, password: 'wrongpassword'
      end

      it 'does not set the sessions[:user_id]' do
        expect(session[:user_id]).to eq(nil)
      end

      it 'redirects to the sign_in page' do
        expect(response).to redirect_to sign_in_path
      end

      it 'sets the error message' do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe 'Destroy session' do 
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    
    it 'sets session[:user_id] to nil' do 
      expect(session[:user_id]).to eq(nil)
    end

    it 'redirects to root path' do 
      expect(response).to redirect_to root_path
    end

    it 'sets the notice' do
      expect(flash[:notice]).not_to be_blank
    end
  end
end



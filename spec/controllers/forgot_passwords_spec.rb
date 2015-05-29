require 'rails_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, { email: "" }
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error" do 
        post :create, { email: "" }
        expect(flash[:error]).to eq("Email cannot be blank")
      end
    end

    context "with existing email" do
      it "redirects to forgot password confirmation page" do
        Fabricate(:user, email: "john@example.com")
        post :create, { email: "john@example.com" }
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "generates token" do
        Fabricate(:user, email: "john@example.com")
        post :create, { email: "john@example.com" }
        expect(assigns(:token)).to be_present
      end

      it "sends email to the users email address" do 
        Fabricate(:user, email: "john@example.com")
        post :create, { email: "john@example.com" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@example.com"])
      end

      it "sends email with the token" do
        john = Fabricate(:user, email: "john@example.com")
        post :create, { email: john.email }
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include(john.token)
      end
    end

    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, { email: "hello@example.com" }
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error" do 
        post :create, { email: "hello@example.com" }
        expect(flash[:error]).to eq("Email does not exist in our system")
      end
    end
  end
end

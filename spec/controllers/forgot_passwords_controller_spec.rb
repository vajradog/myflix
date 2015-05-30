require 'rails_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      before { post :create, { email: "" } }

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error" do
        expect(flash[:error]).to be_present
      end
    end

    context "with existing email" do
      let(:john) { Fabricate(:user, email: "john@example.com") }
      before { post :create, { email: john.email } }

      it "redirects to forgot password confirmation page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends email to the users email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([john.email])
      end

      it "sends email with the token" do
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include(john.token)
      end
    end

    context "with non-existing email" do
      before { post :create, { email: "hello@example.com" } }

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error" do
        expect(flash[:error]).to be_present
      end
    end
  end
end

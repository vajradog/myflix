require 'rails_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_instance_of Invitation
      expect(assigns(:invitation)).to be_new_record
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    before { ActionMailer::Base.deliveries = [] }

    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context "with valid input" do
      let(:alice) { Fabricate(:user) }

      before do
        set_current_user(alice)
        post :create, invitation: { friends_name: "John Doe",
                                    friends_email: "johnny@example.com",
                                    message: "Hey John" }
      end

      it "redirects to invitation new page" do
        expect(response).to redirect_to new_invitation_path
      end

      it "creates an invitation" do
        expect(Invitation.count).to eq(1)
      end

      it "sends invitation email to the friend" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["johnny@example.com"])
      end

      it "sends invitation email to the friend" do
        expect(ActionMailer::Base.deliveries.last).to have_content(alice.full_name)
      end

      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do

      it "renders the :new template" do
        set_current_user
        post :create, invitation: { friends_email: "johnny@example.com",
                                    message: "Hey John" }
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "does not send invitation email to the friend" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end


    end
  end
end

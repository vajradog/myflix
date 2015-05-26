require 'rails_helper'

describe RelationshipsController do   
  describe 'GET index' do     
    it "sets @relationships to the current user's following 
    relationships" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end 

  describe 'DELETE destroy' do
    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "delete the relationship is the current user is the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "redirects to people page" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "does not delete the relationship is the current user is not the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      tom = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: tom, leader: bob)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end

  describe 'POST create' do
    it_behaves_like "require_sign_in" do
      let(:action) { get :create }
    end

    it "redirects to people page" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end

    it "creates a relationship" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(alice.following_relationships.first.leader).to eq(bob)
    end

    it "cannot create a same relationship twice" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      Fabricate(:relationship, follower: alice, leader: bob)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end

    it "does not allow users to follow themselves" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq(0)
    end
  end 
end

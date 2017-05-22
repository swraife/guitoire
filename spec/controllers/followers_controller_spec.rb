require 'rails_helper'

RSpec.describe FollowersController, type: :controller do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:other_performer) { FactoryGirl.create(:performer) }
  let(:follower) { Follower.create(connector: other_performer,
                                       connected: performer,
                                       status: Follower.statuses[:requested]) }

  before(:each) do
    sign_in performer.user
  end

  describe 'PUT #update' do
    it 'accepts the follower' do
      put :update, params: { id: follower.id }, xhr: true

      expect(Follower.accepted.count).to eq(1)
    end
  end

  describe 'POST #create' do
    it 'creates a new follower' do
      post :create, params: { follower: { connected_id: other_performer.id } }, xhr: true

      expect(Follower.count).to eq(1)
    end
  end

  describe 'PUT #destroy' do
    it 'declines a follower request' do
      put :destroy, params: { id: follower.id }, xhr: true

      expect(follower.reload.declined?).to be true
    end
  end
end

require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:friendship) { Friendship.create(connector: other_user,
                                       connected: user,
                                       status: Friendship.statuses[:requested]) }

  before(:each) do
    sign_in user
  end

  describe 'PUT #update' do
    it 'accepts the friendship' do
      put :update, params: { id: friendship.id }, xhr: true

      expect(Friendship.accepted.count).to eq(1)
    end
  end

  describe 'POST #create' do
    it 'creates a new friendship' do
      post :create, params: { friendship: { connected_id: other_user.id } }, xhr: true

      expect(Friendship.count).to eq(1)
    end
  end

  describe 'PUT #destroy' do
    it 'declines a friendship request' do
      put :destroy, params: { id: friendship.id }, xhr: true

      expect(friendship.reload.declined?).to be true
    end
  end
end

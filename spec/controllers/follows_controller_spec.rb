require 'rails_helper'

RSpec.describe FollowsController, type: :controller do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:other_performer) { FactoryGirl.create(:performer) }
  let(:follow) { Follow.create(performer: other_performer, follower: performer) }

  before(:each) do
    sign_in performer.user
  end

  describe 'POST #create' do
    it 'creates a new follow' do
      post :create, params: { follow: { performer_id: other_performer.id } }, xhr: true

      expect(Follow.count).to eq(1)
    end
  end

  describe 'PUT #destroy' do
    it 'declines a follow request' do
      put :destroy, params: { id: follow.id }, xhr: true

      expect(Follow.count).to eq(0)
    end
  end
end

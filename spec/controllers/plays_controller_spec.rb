require 'rails_helper'

RSpec.describe PlaysController, type: :controller do
  let(:feat) { FactoryGirl.create(:feat) }
  let(:performer) { FactoryGirl.create(:performer) }

  before(:each) do
    sign_in performer.user
  end

  describe 'POST #create' do
    it 'creates a new feat role and play' do
      current_user_feat_role = FeatRole.new(feat: feat, owner: performer)
      post :create, params: { play: { feat_id: feat.id } }, xhr: true

      expect(FeatRole.where(owner: performer, feat: feat).count).to eq(1)
      expect(Play.count).to eq(1)
    end

    it 'finds existing feat_role and creates new play' do
      current_user_feat_role = FeatRole.create(feat: feat, owner: performer)

      post :create, params: { play: { feat_id: feat.id } }, xhr: true
      expect(Play.first.feat_role_id).to eq(current_user_feat_role.id)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the play' do
      current_user_feat_role = FeatRole.new(feat: feat, owner: performer)
      play = create(:play,
                    feat: feat,
                    performer: performer,
                    feat_role: current_user_feat_role)

      delete :destroy, params: { id: play.id }, xhr: true
      expect(Play.count).to eq(0)
    end
  end
end
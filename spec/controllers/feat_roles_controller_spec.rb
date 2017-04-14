require 'rails_helper'

RSpec.describe FeatRolesController, type: :controller do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:feat) { FactoryGirl.create(:feat, owner: FactoryGirl.create(:performer)) }

  before(:each) do
    sign_in performer.user
    request.env['HTTP_REFERER'] = 'where_i_came_from'
  end

  describe 'POST #create' do
    it 'creates a new feat_role' do
      post :create, params: { feat_role: { feat_id: feat.id,
                                          global_owner: performer.global_id,
                                          role: 'follower' } }

      expect(FeatRole.follower.count).to eq(1)
    end
  end

  describe 'PUT #update' do
    it 'updates a feat_role' do
      feat_role = feat.feat_roles.create(owner: performer, role: 'follower')
      put :update, params: { id: feat_role.id, feat_role: { feat_id: feat.id,
                                               role: 'viewer' } }
      expect(feat_role.reload.viewer?).to be true
    end
  end
end

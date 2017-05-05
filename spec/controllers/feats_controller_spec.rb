require 'rails_helper'

RSpec.describe FeatsController, type: :controller do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:feat) { FactoryGirl.create(:feat, owner: performer) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:feat)
                                      .merge(generic_list: [''],
                                             admin_performer_ids: [''],
                                             admin_group_ids: ['']) }
  let(:performer2) { FactoryGirl.create(:performer) }
  let(:group) { FactoryGirl.create(:group, creator: performer) }

  before(:each) do
    sign_in performer.user
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { performer_id: performer.id, id: feat.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: { performer_id: performer.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new, params: { performer_id: performer.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'redirects to feat#show' do
      post :create, params: { global_admin_ids: [''],
                              feat: valid_attributes.merge(global_owner: performer.global_id) }
      expect(response).to redirect_to(feat_path(Feat.first))
    end
  end

  describe 'DELETE #destroy' do
    it 'returns http success' do
      delete :destroy, params: { performer_id: performer.id, id: feat.id }
      expect(response).to redirect_to(feats_path(actor_ids: [performer.global_id]))
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { performer_id: performer.id, id: feat.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    it 'redirects to feat#show' do
      put :update, params: { performer_id: performer.id,
                             id: feat.id,
                             global_admin_ids: [''],
                             feat: valid_attributes,
                             feat_role: { private_list: [''] } }
      expect(response).to redirect_to(performer_feat_path(performer, feat))
    end

    it 'adds and deletes feat_roles for performers and groups' do
      feat.admin_performers << performer2
      put :update, params: { performer_id: performer.id,
                             id: feat.id,
                             feat_role: { private_list: [''] },
                             feat: valid_attributes.merge(admin_performer_ids: [performer.id], admin_group_ids: [group.id]) }

      feat.reload
      expect(response).to redirect_to(performer_feat_path(performer, feat))
      expect(feat.admin_performers).to match_array(performer)
      expect(feat.admin_groups).to match_array(group)
    end
  end
end

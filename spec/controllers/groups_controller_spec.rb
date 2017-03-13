require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group, creator: user) }

  before(:each) do
    sign_in user
  end

  describe 'GET #index' do
    it 'is successful' do
      get :index, params: { user_id: user.id }

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'is successful' do
      get :show, params: { id: group.id }

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'is successful' do
      get :new

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'creates a new group' do
      post :create, params: { group: { name: 'Group!', creator_id: user.id } }

      expect(Group.count).to eq(1)
    end
  end

  describe 'GET #edit' do
    it 'is successful' do
      get :edit, params: { id: group.id }

      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    it 'updates the group' do
      put :update, params: { id: group.id, group: { name: 'New Name' } }

      expect(Group.first.name).to eq('New Name')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the group' do
      delete :destroy, params: { id: group.id }

      expect(Group.count).to eq(0)
    end
  end
end
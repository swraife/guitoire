require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group, creator: user) }

  before(:each) do
    sign_in user
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
end
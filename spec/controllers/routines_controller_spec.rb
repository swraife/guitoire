require 'rails_helper'

RSpec.describe RoutinesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:routine) { FactoryGirl.create(:routine, owner: user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:routine).merge(global_owner: user.global_id) }

  before(:each) do
    @request.env['HTTP_REFERER'] = '/home'
    sign_in user
  end

  describe 'GET #new' do
    it 'returns HTTP success' do
      get :new, params: { user_id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns HTTP success' do
      post :create, params: { user_id: user.id, routine: valid_attributes }
      expect(Routine.count).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'returns HTTP success' do
      get :show, params: { id: routine.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index' do
    it 'returns HTTP success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end

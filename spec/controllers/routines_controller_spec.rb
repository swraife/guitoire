require 'rails_helper'

RSpec.describe RoutinesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:routine) }

  before(:each) do
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
      expect(response).to have_http_status(:success)
    end
  end
end

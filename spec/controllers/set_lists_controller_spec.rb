require 'rails_helper'

RSpec.describe SetListsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:set_list) }

  before(:each) do
    sign_in user
  end

  describe 'GET #new' do
    it 'returns HTTP success' do
      get :new, user_id: user.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns HTTP success' do
      post :create, user_id: user.id, set_list: valid_attributes
      expect(response).to have_http_status(:success)
    end
  end
end

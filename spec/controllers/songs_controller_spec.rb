require 'rails_helper'

RSpec.describe SongsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:song) { FactoryGirl.create(:song, user: user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:song) }

  before(:each) do
    sign_in user
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, user_id: user.id, id: song.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index, user_id: user.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new, user_id: user.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns http success' do
      post :create, user_id: user.id, song: valid_attributes
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE #destroy' do
    it 'returns http success' do
      delete :destroy, user_id: user.id, id: song.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, user_id: user.id, id: song.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    it 'returns http success' do
      put :update, user_id: user.id, id: song.id, song: valid_attributes
      expect(response).to have_http_status(:success)
    end
  end
end

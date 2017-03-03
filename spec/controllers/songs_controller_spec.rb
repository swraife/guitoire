require 'rails_helper'

RSpec.describe SongsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:song) { FactoryGirl.create(:song, creator: user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:song)
                                      .merge(composer_list: [''],
                                             version_list: [''],
                                             generic_list: [''],
                                             genre_list: [''],
                                             admin_user_ids: ['']) }

  before(:each) do
    sign_in user
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { user_id: user.id, id: song.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: { user_id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new, params: { user_id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'redirects to song#show' do
      post :create, params: { user_id: user.id, song: valid_attributes }
      expect(response).to redirect_to(user_song_path(user, Song.first))
    end
  end

  describe 'DELETE #destroy' do
    it 'returns http success' do
      delete :destroy, params: { user_id: user.id, id: song.id }
      expect(response).to redirect_to(user_songs_path(user))
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { user_id: user.id, id: song.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    it 'redirects to song#show' do
      put :update, params: { user_id: user.id, id: song.id, song: valid_attributes }
      expect(response).to redirect_to(user_song_path(user, song))
    end
  end
end

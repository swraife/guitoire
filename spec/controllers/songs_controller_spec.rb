require 'rails_helper'

RSpec.describe SongsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:song) { FactoryGirl.create(:song, owner: user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:song)
                                      .merge(composer_list: [''],
                                             version_list: [''],
                                             generic_list: [''],
                                             genre_list: [''],
                                             admin_user_ids: [''],
                                             admin_group_ids: ['']) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group, creator: user) }

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
      post :create, params: { user_id: user.id, global_admin_ids: [''], song: valid_attributes }
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
      put :update, params: { user_id: user.id, id: song.id, global_admin_ids: [''], song: valid_attributes }
      expect(response).to redirect_to(user_song_path(user, song))
    end

    it 'adds and deletes song_roles for users and groups' do
      song.admin_users << user2
      put :update, params: { user_id: user.id, id: song.id, song: valid_attributes.merge(admin_user_ids: [user.id], admin_group_ids: [group.id]) }

      song.reload
      expect(response).to redirect_to(user_song_path(user, song))
      expect(song.admin_users).to match_array(user)
      expect(song.admin_groups).to match_array(group)
    end
  end
end

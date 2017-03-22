require 'rails_helper'

RSpec.describe SongsController, type: :controller do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:song) { FactoryGirl.create(:song, owner: performer) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:song)
                                      .merge(composer_list: [''],
                                             version_list: [''],
                                             generic_list: [''],
                                             genre_list: [''],
                                             admin_performer_ids: [''],
                                             admin_group_ids: ['']) }
  let(:performer2) { FactoryGirl.create(:performer) }
  let(:group) { FactoryGirl.create(:group, creator: performer) }

  before(:each) do
    sign_in performer.user
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { performer_id: performer.id, id: song.id }
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
    it 'redirects to song#show' do
      post :create, params: { global_admin_ids: [''],
                              song: valid_attributes.merge(global_owner: performer.global_id) }
      expect(response).to redirect_to(song_path(Song.first))
    end
  end

  describe 'DELETE #destroy' do
    it 'returns http success' do
      delete :destroy, params: { performer_id: performer.id, id: song.id }
      expect(response).to redirect_to(performer_songs_path(performer))
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { performer_id: performer.id, id: song.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    it 'redirects to song#show' do
      put :update, params: { performer_id: performer.id, id: song.id, global_admin_ids: [''], song: valid_attributes }
      expect(response).to redirect_to(performer_song_path(performer, song))
    end

    it 'adds and deletes song_roles for performers and groups' do
      song.admin_performers << performer2
      put :update, params: { performer_id: performer.id, id: song.id, song: valid_attributes.merge(admin_performer_ids: [performer.id], admin_group_ids: [group.id]) }

      song.reload
      expect(response).to redirect_to(performer_song_path(performer, song))
      expect(song.admin_performers).to match_array(performer)
      expect(song.admin_groups).to match_array(group)
    end
  end
end

require 'rails_helper'

RSpec.describe SongRolesController, type: :controller do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:song) { FactoryGirl.create(:song, owner: FactoryGirl.create(:performer)) }

  before(:each) do
    sign_in performer.user
    request.env['HTTP_REFERER'] = 'where_i_came_from'
  end

  describe 'POST #create' do
    it 'creates a new song_role' do
      post :create, params: { song_role: { song_id: song.id,
                                          global_owner: performer.global_id,
                                          role: 'follower' } }

      expect(SongRole.follower.count).to eq(1)
    end
  end

  describe 'PUT #update' do
    it 'updates a song_role' do
      song_role = song.song_roles.create(owner: performer, role: 'follower')
      put :update, params: { id: song_role.id, song_role: { song_id: song.id,
                                               role: 'viewer' } }
      expect(song_role.reload.viewer?).to be true
    end
  end
end

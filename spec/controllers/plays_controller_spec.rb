require 'rails_helper'

RSpec.describe PlaysController, type: :controller do
  let(:song) { FactoryGirl.create(:song) }
  let(:performer) { FactoryGirl.create(:performer) }

  before(:each) do
    sign_in performer.user
  end

  describe 'POST #create' do
    it 'creates a new song role and play' do
      current_user_song_role = SongRole.new(song: song, owner: performer)
      post :create, params: { play: { song_id: song.id } }, xhr: true

      expect(SongRole.where(owner: performer, song: song).count).to eq(1)
      expect(Play.count).to eq(1)
    end

    it 'finds existing song_role and creates new play' do
      current_user_song_role = SongRole.create(song: song, owner: performer)

      post :create, params: { play: { song_id: song.id } }, xhr: true
      expect(Play.first.song_role_id).to eq(current_user_song_role.id)
    end
  end
end
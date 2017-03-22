require 'rails_helper'

RSpec.describe SetListSongsController, type: :controller do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:routine) { FactoryGirl.create(:routine, owner: performer) }
  let(:set_list_song) { FactoryGirl.create(:set_list_song, routine: routine) }

  before(:each) do
    sign_in performer.user
  end

  describe 'DELETE #destroy' do
    it 'deletes the set_list_song' do
      delete :destroy, params: { id: set_list_song.id }, xhr: true
      expect(SetListSong.count).to eq(0)
    end
  end
end
require 'rails_helper'

RSpec.describe SetListSongsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:routine) { FactoryGirl.create(:routine, owner: user) }
  let(:set_list_song) { FactoryGirl.create(:set_list_song, routine: routine) }

  before(:each) do
    sign_in user
  end

  describe 'DELETE #destroy' do
    it 'deletes the set_list_song' do
      delete :destroy, params: { id: set_list_song.id }, xhr: true
      expect(SetListSong.count).to eq(0)
    end
  end
end
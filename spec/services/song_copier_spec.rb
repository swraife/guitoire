require 'rails_helper'

RSpec.describe SongCopier do
  let(:song) { FactoryGirl.create(:song) }
  let(:performer) { FactoryGirl.create(:performer) }

  describe '#copy!' do
    it 'copies the song' do
      song
      expect do
        described_class.new(song: song, copy_creator: performer).copy! 
      end.to change(Song, :count).by(1)
    end

    it 'copies the tags' do
      song.update!(generic_list: ['tag!'])
      copy = described_class.new(song: song, copy_creator: performer).copy!
      expect(copy.generic_list).to include('tag!')
    end

    it 'copies each resource' do
      song.resources.create
      expect do
        described_class.new(song: song, copy_creator: performer).copy!
      end.to change(Resource, :count).by(1)
    end
  end
end
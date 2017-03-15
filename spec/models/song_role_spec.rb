# == Schema Information
#
# Table name: song_roles
#
#  id          :integer          not null, primary key
#  song_id     :integer
#  owner_id    :integer
#  role        :integer          default("viewer")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  plays_count :integer          default(0)
#  owner_type  :string
#

require 'rails_helper'

RSpec.describe SongRole, type: :model do
  let(:song) { FactoryGirl.create(:song) }
  let(:song_role) { FactoryGirl.create(:song_role, song: song, user: user) }
  let(:user) { FactoryGirl.create(:user) }

  describe '.order_by_plays_count' do
    it 'sorts by plays_count' do
      2.times { Play.create(song_role: song_role, user: user) }
      Play.create(song_role: Song.create(name: 'A', creator: user).song_roles.first, user: user)

      expect(described_class.order_by_plays_count.first).to eq(song_role)
    end
  end
end

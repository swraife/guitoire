# == Schema Information
#
# Table name: performers
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  name                :string
#  public_name         :string
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  description         :text
#  email               :string
#  visibility          :integer          default("everyone")
#  settings            :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Performer, type: :model do
  let(:performer) { FactoryGirl.create(:performer) }

  describe '#song_tags' do
    it 'returns all tags when no context is given' do
      song = FactoryGirl.create(:song, genre_list: [:jazz])
      performer.songs << song

      expect(performer.song_tags).to include(ActsAsTaggableOn::Tag.first)
    end
  end
end

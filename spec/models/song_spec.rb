# == Schema Information
#
# Table name: songs
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  music_key      :string
#  tempo          :integer
#  composer_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  creator_id     :integer
#  scale          :string
#  time_signature :string
#  permission     :integer          default("copiable")
#  owner_id       :integer
#  owner_type     :string
#

require 'rails_helper'

RSpec.describe Song, type: :model do
  let(:song) { FactoryGirl.create(:song, creator: user) }
  let(:user) { FactoryGirl.create(:user) }
end

# == Schema Information
#
# Table name: feats
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
#  visibility     :integer          default("everyone")
#

require 'rails_helper'

RSpec.describe Feat, type: :model do
  let(:feat) { FactoryGirl.create(:feat, creator: performer) }
  let(:performer) { FactoryGirl.create(:performer) }
end

# == Schema Information
#
# Table name: song_resources
#
#  id          :integer          not null, primary key
#  song_id     :integer
#  resource_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe SongResource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

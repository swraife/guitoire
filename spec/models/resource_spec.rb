# == Schema Information
#
# Table name: resources
#
#  id                :integer          not null, primary key
#  name              :string
#  main_file_name    :string
#  main_content_type :string
#  main_file_size    :integer
#  main_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Resource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

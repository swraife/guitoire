# == Schema Information
#
# Table name: file_resources
#
#  id                :integer          not null, primary key
#  main_file_name    :string
#  main_content_type :string
#  main_file_size    :integer
#  main_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe FileResource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

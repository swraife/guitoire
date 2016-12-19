# == Schema Information
#
# Table name: set_list_users
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  set_list_id :integer
#  role        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe SetListUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

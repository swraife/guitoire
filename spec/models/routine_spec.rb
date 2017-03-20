# == Schema Information
#
# Table name: routines
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :integer
#  owner_type  :string
#  visibility  :integer          default("everyone")
#

require 'rails_helper'

RSpec.describe Routine, type: :model do
  let(:routine) { FactoryGirl.create(:routine) }
  let(:user) { FactoryGirl.create(:user) }

  describe '.visible_to' do
    it 'returns routines with visibility equal to everyone' do
      expect(described_class.visible_to User.new).to include(routine)
    end

    it 'does not include routines with visibility equal to only_admins' do
      routine.only_admins!
      expect(described_class.visible_to User.new).not_to include(routine)
    end

    it 'returns only_admins routines if user has admin routine_role' do
      routine.admin_users << user
      expect(described_class.visible_to user).to include(routine)
    end

    it 'returns routines.only_admins if user has group w admin routine_role' do
      group = FactoryGirl.create(:group)
      user.groups << group
      routine.admin_groups << group
      expect(described_class.visible_to user).to include(routine)
    end
  end
end

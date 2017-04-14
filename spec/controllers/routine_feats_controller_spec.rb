require 'rails_helper'

RSpec.describe RoutineFeatsController, type: :controller do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:routine) { FactoryGirl.create(:routine, owner: performer) }
  let(:routine_feat) { FactoryGirl.create(:routine_feat, routine: routine) }

  before(:each) do
    sign_in performer.user
  end

  describe 'DELETE #destroy' do
    it 'deletes the routine_feat' do
      delete :destroy, params: { id: routine_feat.id }, xhr: true
      expect(RoutineFeat.count).to eq(0)
    end
  end
end
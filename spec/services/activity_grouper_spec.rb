require 'rails_helper'

RSpec.describe ActivityGrouper do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:feat) { FactoryGirl.create(:feat) }

  describe '#grouped_activities' do
    it 'groups play.create activities by day and user' do
      activities = [PublicActivity::Activity.new(key: 'play.create', owner: user1, created_at: 1.days.ago)]
      2.times { activities.push(PublicActivity::Activity.new(key: 'play.create', owner: user1, created_at: Time.now)) }
      activities.push(PublicActivity::Activity.new(key: 'play.create', owner: user2, created_at: Time.now))

      expect(described_class.new(activities).grouped_activities.length).to eq(3)
    end
  end

  describe '#each' do
    it 'yields an array of activities' do
      activities = []
      2.times { activities.push(PublicActivity::Activity.new(key: 'play.create', owner: user1, created_at: Time.now)) }
      result = [] 
      described_class.new(activities).each { |arr| result.push(arr.map(&:class)) }
      expect(result).to eq([[PublicActivity::Activity, PublicActivity::Activity]])
    end
  end
end
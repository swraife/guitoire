require 'rails_helper'

RSpec.describe FeatCopier do
  let(:feat) { FactoryGirl.create(:feat) }
  let(:performer) { FactoryGirl.create(:performer) }

  describe '#copy!' do
    it 'copies the feat' do
      feat
      expect do
        described_class.new(feat: feat, copy_creator: performer).copy!
      end.to change(Feat, :count).by(1)
    end

    it 'copies the tags' do
      feat.update!(generic_list: ['tag!'])
      copy = described_class.new(feat: feat, copy_creator: performer).copy!
      expect(copy.generic_list).to include('tag!')
    end

    it 'copies each resource' do
      feat.resources.create
      expect do
        described_class.new(feat: feat, copy_creator: performer).copy!
      end.to change(Resource, :count).by(1)
    end
  end
end

# == Schema Information
#
# Table name: url_resources
#
#  id         :integer          not null, primary key
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UrlResource, type: :model do
  describe '#displayable_in_browser' do
    it 'returns true' do
      expect(subject.displayable_in_browser?).to be true
    end
  end

  describe '#url_name' do
    it 'returns url' do
      subject.url = 'http://example.com'
      expect(subject.url_name).to eq('http://example.com')
    end
  end

  describe '#icon' do
    it 'returns "fa-link"' do
      expect(subject.icon).to eq('fa-link')
    end
  end
end

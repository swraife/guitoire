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
  describe '#displayable_in_browser' do
    it 'returns true for image types' do
      subject.main_content_type = 'image/png'
      expect(subject.displayable_in_browser?).to be true
    end
  end

  describe '#url_name' do
    it 'returns url' do
      subject.main_file_name = 'my_file.pdf'
      expect(subject.url_name).to eq('my_file.pdf')
    end
  end

  describe '#icon' do
    it 'defaults to "fa-file-o"' do
      expect(subject.icon).to eq('fa-file-o')
    end

    it 'returns fa-file-image-o for images' do
      subject.main_content_type = 'image/gif'
      expect(subject.icon).to eq('fa-file-image-o')
    end

    it 'returns fa-file-pdf-o for pdfs' do
      subject.main_content_type = 'application/pdf'
      expect(subject.icon).to eq('fa-file-pdf-o')
    end
  end
end

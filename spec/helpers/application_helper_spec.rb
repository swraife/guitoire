require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#truncated_sentence_array' do
    it 'handles arrays with length 2' do
      expect(truncated_sentence_array([1,2])).to eq([1, ' and ', 2])
    end

    it 'handles arrays with length 3' do
      expect(truncated_sentence_array([1,2,3])).to eq([1, ', ', 2, ', and ', 3])
    end

    it 'default truncates to 3 items' do
      expect(truncated_sentence_array([1,2,3,4])).to eq([1, ', ', 2, ', ', 3, ', and 1 more'])
    end

    it 'handles longer truncate lengths' do
      expect(truncated_sentence_array([1,2,3,4], truncate_length: 4)).to eq([1, ', ', 2, ', ', 3, ', and ', 4])
    end

    it 'handles shorter truncate lengths' do
      expect(truncated_sentence_array([1,2,3,4], truncate_length: 2)).to eq([1, ', ', 2, ', and 2 more'])
    end
  end
end
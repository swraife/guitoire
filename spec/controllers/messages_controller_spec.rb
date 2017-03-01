require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    sign_in user
  end

  describe '#POST create' do
    it 'creates a new message and message_copies' do
      xhr :post, :create, params: { message: { content: 'test' } }

      expect(Message.count).to eq(1)
    end
  end
end
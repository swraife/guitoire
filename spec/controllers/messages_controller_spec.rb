require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:performer) { create(:performer, user: user) }
  let(:message_thread) { FactoryGirl.create(:message_thread) }

  before(:each) do
    sign_in performer.user
  end

  describe '#POST create' do
    it 'creates a new message and message_copies' do
      post :create, params: { message: { content: 'test', message_thread_id: message_thread.id } }, xhr: true

      expect(Message.count).to eq(1)
    end
  end
end
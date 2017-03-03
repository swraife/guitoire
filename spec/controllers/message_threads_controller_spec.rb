require 'rails_helper'

RSpec.describe MessageThreadsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    sign_in user
  end

  describe 'POST #create' do
    it 'creates a new message and message_copies' do
      post :create, params: { message_thread: { user_ids: [user.id] }, message: { content: 'test' } }, xhr: true

      expect(MessageThread.count).to eq(1)
      expect(Message.count).to eq(1)
    end
  end

  describe 'GET #index' do
    it 'is successful' do
      get :index

      expect(response).to have_http_status(:success)
    end
  end
end
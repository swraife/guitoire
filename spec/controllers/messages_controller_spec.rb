require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    sign_in user
  end

  describe '#GET new' do
    it 'is successful' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe '#GET index' do
    it 'is successful' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe '#POST create' do
    it 'creates a new message and message_copies' do
      post :create, params: { message: { content: 'test' } }

      expect(Message.count).to eq(1)
    end
  end
end
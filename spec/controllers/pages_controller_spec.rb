require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let(:performer) { FactoryGirl.create(:performer) }

  before(:each) do
    sign_in performer.user
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end

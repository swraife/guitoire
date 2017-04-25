require 'rails_helper'

RSpec.describe RoutinesController, type: :controller do
  let(:performer) { FactoryGirl.create(:performer) }
  let(:other_performer) { FactoryGirl.create(:performer) }
  let(:routine) { FactoryGirl.create(:routine, owner: performer) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:routine).merge(global_owner: performer.global_id) }

  before(:each) do
    @request.env['HTTP_REFERER'] = '/home'
    sign_in performer.user
  end

  describe 'GET #show' do
    it 'returns HTTP success' do
      get :show, params: { id: routine.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index' do
    it 'returns HTTP success' do
      get :index, params: { performer_id: performer.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns HTTP success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns HTTP success' do
      post :create, params: { routine: valid_attributes }
      expect(Routine.count).to eq(1)
    end
  end

  describe 'GET #edit' do
    it 'returns HTTP success when performer is the routine owner' do
      get :edit, params: { id: routine.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns HTTP success when performer is an admin_performer' do
      other_routine = FactoryGirl.create(:routine, owner: other_performer )
      other_routine.admin_performers << performer

      get :edit, params: { id: other_routine.id }
      expect(response).to have_http_status(:success)      
    end
  end

  describe 'PUT #update' do
    it 'updates the routine' do
      put :update, params: { id: routine.id,
                             routine: valid_attributes.merge(name: 'New!') }

      expect(Routine.first.name).to eq('New!')
    end
  end
end

require 'rails_helper'

RSpec.describe RoutinesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:routine) { FactoryGirl.create(:routine, owner: user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:routine).merge(global_owner: user.global_id) }

  before(:each) do
    @request.env['HTTP_REFERER'] = '/home'
    sign_in user
  end

  describe 'GET #show' do
    it 'returns HTTP success' do
      get :show, params: { id: routine.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index' do
    it 'returns HTTP success' do
      get :index, params: { user_id: user.id }
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
    it 'returns HTTP success when user is the routine owner' do
      get :edit, params: { id: routine.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns HTTP success when user is an admin_user' do
      other_routine = FactoryGirl.create(:routine, owner: other_user )
      other_routine.admin_users << user

      get :edit, params: { id: other_routine.id }
      expect(response).to have_http_status(:success)      
    end

    it 'raises exception when user is not a routine admin' do
      other_routine = FactoryGirl.create(:routine, owner: other_user )

      expect do
        get :edit, params: { id: other_routine.id }
      end.to raise_error(CanCan::AccessDenied)
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

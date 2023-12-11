require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:client) { create(:client, id: '0504427758') }

    it 'returns a successful response' do
      get :show, params: { id: client.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns a successful response' do
      get :show, params: { id: client.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      { client: { id: '0443', first_name: 'John', last_name: 'Doe', address: '123 Main St', email: 'john@example.com',
                  phone: '555-1234', id_type: 'RUC' } }
    end
    let(:invalid_params) do
      { client: { first_name: 'John', last_name: 'Doe', address: '123 Main St', email: 'john@example.com',
                  phone: '555-1234', id_type: 'InvalidType' } }
    end

    context 'with valid parameters' do
      it 'creates a new client' do
        expect do
          post :create, params: valid_params
        end.to change(Client, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: valid_params
        expect(response).to have_http_status(:accepted)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new client' do
        expect do
          post :create, params: invalid_params
        end.to_not change(Client, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        post :create, params: invalid_params
        response_body = JSON.parse(response.body)
        expect(response_body).to be_present
      end
    end
  end

  describe 'PUT #update' do
    let(:client) { create(:client, id: '0504427758') }
    let(:valid_params) { { id: client.id, client: { first_name: 'UpdatedName' } } }
    let(:invalid_params) { { id: client.id, client: { id_type: 'InvalidType' } } }

    context 'with valid parameters' do
      it 'updates the client' do
        put :update, params: valid_params
        expect(client.reload.first_name).to eq('UpdatedName')
      end

      it 'returns a successful response' do
        put :update, params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the client' do
        put :update, params: invalid_params
        expect(JSON.parse(response.body)).to include('error')
      end

      it 'returns unprocessable entity status' do
        put :update, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        put :update, params: invalid_params
        expect(JSON.parse(response.body)).to include('error')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:client) { create(:client, id: '0504427758') }

    it 'destroys the client' do
      expect do
        delete :destroy, params: { id: client.id }
      end.to change(Client, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: client.id }
      expect(response).to have_http_status(:success)
    end
  end
end

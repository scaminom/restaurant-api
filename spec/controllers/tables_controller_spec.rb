require 'rails_helper'

RSpec.describe TablesController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:table) { create(:table) }

    it 'returns a successful response' do
      get :show, params: { id: table.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { table: { status: 'free', capacity: 4 } } }
    let(:invalid_params) { { table: { statuss: 'test', caapacity: nil } } }

    context 'with valid parameters' do
      it 'creates a new table' do
        expect do
          post :create, params: valid_params
        end.to change(Table, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: valid_params
        expect(response).to have_http_status(:accepted)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new table' do
        expect do
          post :create, params: invalid_params
        end.to_not change(Table, :count)
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

    context 'when the maximum table limit is reached' do
      before { allow(Table).to receive(:count).and_return(7) }

      it 'does not create a new table' do
        expect do
          post :create, params: valid_params
        end.to_not change(Table, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: valid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns errors messages' do
        post :create, params: invalid_params

        response_body = JSON.parse(response.body)

        expected_errors = [
          "Status can't be blank",
          'Maximum number of tables (7) reached. Cannot create more.',
          'Status is not a valid status'
        ]

        expect(response_body).to eq(expected_errors)
      end
    end
  end

  describe 'PUT #update' do
    let(:table) { create(:table) }
    let(:valid_params) { { id: table.id, table: { status: 'occupied', capacity: 6 } } }
    let(:invalid_params) { { id: table.id, table: { status: 'frees', capacity: nil } } }

    context 'with valid parameters' do
      it 'updates the table' do
        put :update, params: valid_params
        expect(table.reload.status).to eq('occupied')
        expect(table.reload.capacity).to eq(6)
      end

      it 'returns a successful response' do
        put :update, params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the table' do
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
    let!(:table) { create(:table) }

    it 'destroys the table' do
      expect do
        delete :destroy, params: { id: table.id }
      end.to change(Table, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: table.id }
      expect(response).to have_http_status(:success)
    end
  end
end

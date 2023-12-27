require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
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
    let(:invoice) { create(:invoice) }

    it 'returns a successful response' do
      get :show, params: { id: invoice.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:order) { create(:order, :with_waiter) }
    let(:client) { create(:client, id: '0504427758') }
    let(:invoice) { create(:invoice) }
    let(:valid_params) do
      {
        invoice: {
          order_number: order.id,
          payment_method: 'transfer',
          client_id: client.id
        }
      }
    end
    let(:invalid_params) { { invoice: attributes_for(:invoice, quantity: nil) } }

    context 'with valid parameters' do
      it 'creates a new invoice' do
        expect do
          post :create, params: valid_params
        end.to change(Invoice, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: valid_params
        expect(response).to have_http_status(:accepted)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new invoice' do
        expect do
          post :create, params: invalid_params
        end.to_not change(Invoice, :count)
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
    let(:invoice) { create(:invoice) }
    let(:valid_params) { { id: invoice.id, invoice: { payment_method: 'online' } } }
    let(:invalid_params) { { id: invoice.id, invoice: { payment_method: 'test' } } }

    context 'with valid parameters' do
      it 'updates the invoice' do
        put :update, params: valid_params
        expect(invoice.reload.payment_method).to eq('online')
      end

      it 'returns a successful response' do
        put :update, params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the invoice' do
        put :update, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        put :update, params: invalid_params
        response_body = JSON.parse(response.body)
        expect(response_body).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:invoice) { create(:invoice) }

    it 'destroys the invoice' do
      expect do
        delete :destroy, params: { id: invoice.id }
      end.to change(Invoice, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: invoice.id }
      expect(response).to have_http_status(:success)
    end
  end
end

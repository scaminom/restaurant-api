require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
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
    let(:order) { create(:order, :with_waiter) }

    it 'returns a successfull response' do
      get :show, params: { id: order.order_number }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:product1) { create(:product) }
    let(:product2) { create(:product) }
    let(:table) { create(:table) }
    let(:valid_params) do
      {
        order: {
          waiter_id: user.id,
          table_id: table.id,
          items_attributes: [
            { "product_id": product1.id, "quantity": 4 },
            { "product_id": product2.id, "quantity": 8 }
          ]
        }
      }
    end
    let(:invalid_params) { { order: { status: 'test' } } }

    context 'with valid parameters' do
      it 'creates a new order' do
        expect do
          post :create, params: valid_params
        end.to change(Order, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: valid_params
        expect(response).to have_http_status(:accepted)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new order' do
        expect do
          post :create, params: invalid_params
        end.to_not change(Order, :count)
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
    let(:order) { create(:order, :with_waiter) }
    let(:valid_params) { { id: order.id, order: { status: 'ready' } } }
    let(:invalid_params) { { id: order.id, order: { status: 'test' } } }

    context 'with valid parameters' do
      it 'updates the order' do
        put :update, params: valid_params
        expect(order.reload.status).to eq('ready')
      end

      it 'returns a successful response' do
        put :update, params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the order' do
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
    let!(:order) { create(:order, :with_waiter) }

    it 'destroys the item' do
      expect do
        delete :destroy, params: { id: order.id }
      end.to change(Order, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: order.id }
      expect(response).to have_http_status(:success)
    end
  end
end

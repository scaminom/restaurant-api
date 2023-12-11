require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:item) { create(:item) }

    it 'returns a successful response' do
      get :show, params: { id: item.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:product) { create(:product) }
    let(:order) { create(:order, :with_waiter) }
    let(:valid_params) do
      {
        quantity: 12,
        product_id: product.id,
        order_number: order.order_number
      }
    end
    let(:invalid_params) { { item: attributes_for(:item, quantity: nil) } }

    context 'with valid parameters' do
      it 'creates a new item' do
        expect do
          post :create, params: { item: valid_params }
        end.to change(Item, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: { item: valid_params }
        expect(response).to have_http_status(:accepted)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new item' do
        expect do
          post :create, params: invalid_params
        end.to_not change(Item, :count)
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
    let(:item) { create(:item) }
    let(:valid_params) { { id: item.id, item: { quantity: 5 } } }
    let(:invalid_params) { { id: item.id, item: { quantity: nil } } }

    context 'with valid parameters' do
      it 'updates the item' do
        put :update, params: valid_params
        expect(item.reload.quantity).to eq(5)
      end

      it 'returns a successful response' do
        put :update, params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the item' do
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
    let!(:item) { create(:item) }

    it 'destroys the item' do
      expect do
        delete :destroy, params: { id: item.id }
      end.to change(Item, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: item.id }
      expect(response).to have_http_status(:success)
    end
  end
end

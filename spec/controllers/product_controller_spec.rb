require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:product) { create(:product) }

    it 'returns a successful response' do
      get :show, params: { id: product.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      {
        product: {
          name: 'rice',
          description: Faker::Lorem.sentence,
          price: Faker::Commerce.price(range: 1..100.0),
          category: 'food',
          image: Faker::Internet.url
        }
      }
    end

    let(:invalid_params) do
      {
        product: {
          name: nil,
          description: Faker::Lorem.sentence,
          price: nil,
          category: 'llfa',
          image: Faker::Internet.url
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new product' do
        expect do
          post :create, params: valid_params
        end.to change(Product, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: valid_params
        expect(response).to have_http_status(:accepted)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new product' do
        expect do
          post :create, params: invalid_params
        end.to_not change(Product, :count)
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
    let(:product) { create(:product) }
    let(:valid_params) { { id: product.id, product: { category: 'food', price: 4.50 } } }
    let(:invalid_params) { { id: product.id, product: { category: 'flls', price: nil } } }

    context 'with valid parameters' do
      it 'updates the product' do
        put :update, params: valid_params
        expect(product.reload.category).to eq('food')
        expect(product.reload.price).to eq(4.50)
      end

      it 'returns a successful response' do
        put :update, params: valid_params
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the product' do
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
    let!(:product) { create(:product) }

    it 'destroys the product' do
      expect do
        delete :destroy, params: { id: product.id }
      end.to change(Product, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: product.id }
      expect(response).to have_http_status(:success)
    end
  end
end


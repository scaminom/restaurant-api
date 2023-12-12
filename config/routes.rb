Rails.application.routes.draw do
  resources :invoices
  resources :events
  resources :items
  resources :orders
  devise_for :users
  resources :tables
  resources :products
  resources :clients

  resources :tables do
    member do
      post 'occupy'
      post 'release'
    end
  end

  match '*unmatched', to: 'application#no_route_found', via: :all
end

Rails.application.routes.draw do
  resources :invoices
  resources :events
  resources :items
  resources :orders
  devise_for :users
  resources :tables
  resources :products
  resources :clients

  match '*unmatched', to: 'application#not_found_method', via: :all
end

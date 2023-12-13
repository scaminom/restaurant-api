Rails.application.routes.draw do
  resources :users
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :users
  resources :invoices
  resources :events
  resources :items
  resources :orders
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

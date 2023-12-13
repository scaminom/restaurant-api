Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :invoices
  resources :events
  resources :items
  resources :orders
  resources :tables
  resources :products
  resources :clients

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index show create update destroy]
    end
  end

  resources :tables do
    member do
      post 'occupy'
      post 'release'
    end
  end

  match '*unmatched', to: 'application#no_route_found', via: :all
end

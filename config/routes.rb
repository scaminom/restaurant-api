Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

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
  resources :cooks
  resources :waiters

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

  resources :orders do
    member do
      put 'ready'
      put 'in_process'
    end
  end

  match '*unmatched', to: 'application#no_route_found', via: :all
end

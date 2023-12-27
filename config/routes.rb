Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :invoices
  resources :events
  resources :items,     only: %i[index show create update destroy]
  resources :orders,    only: %i[index show create update in_process dispatch_item]
  resources :tables,    only: %i[index show update occupy release]
  resources :products,  only: %i[index show create update destroy]
  resources :clients
  resources :cooks
  resources :waiters

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index show create update]
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
      put 'in_process'
      put 'dispatch_order'
    end
  end

  patch '/orders/:id/dispatch_item/:item_id', to: 'orders#dispatch_item'

  match '*unmatched', to: 'application#no_route_found', via: :all
end

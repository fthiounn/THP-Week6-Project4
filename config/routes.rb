Rails.application.routes.draw do
  devise_for :users
  resources :attendances
  resources :events do
    resources :charges
  end
  resources :users
  resources :teams, only: [:index]
  resources :contacts, only: [:index]

  root 'events#index'
end

Rails.application.routes.draw do
  resources :gyms

  devise_for :users, controllers: { registrations: "registrations" }
  root to: "home#index"
  resources :coaches do
    collection do
      get 'search'
    end
  end
  resources :profiles
end

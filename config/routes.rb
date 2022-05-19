Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/api/v1/merchants/find", to: "api/v1/search_merchants#show"

  get "/api/v1/items/find_all", to: "api/v1/search_items#index"

  namespace :api do
    namespace :v1 do

      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], controller: :item_merchant
      end

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end

    end
  end
end

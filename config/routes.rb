Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :menus
  resources :artworks
  resources :purchases
  resources :trusts
  resources :purchase_slips do
    collection do
      get :artworkGet
      get :priceSet
    end
  end
  resources :purchase_cancel_slips do
    collection do
      get :artworkGet
    end
  end
  resources :trust_slips do
    collection do
      get :artworkGet
      get :priceSet
    end
  end
  resources :trust_return_slips do
    collection do
      get :artworkGet
    end
  end
  resources :sale_slips do
    collection do
      get :artworkGet
      get :priceSet
    end
  end
  resources :sale_cancel_slips do
    collection do
      get :artworkGet
    end
  end
  resources :consign_slips do
    collection do
      get :artworkGet
      get :priceSet
    end
  end
  resources :consign_return_slips do
    collection do
      get :artworkGet
    end
  end
  resources :customer_lists
  resources :stock_lists
  resources :purchase_lists
  resources :trust_lists
  resources :consign_lists
  resources :sale_lists
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get    '/login',          to: 'sessions#new'
  post   '/login',          to: 'sessions#create'
  delete '/logout',         to: 'sessions#destroy'
  get    '/menus',          to: 'menus#index'
  get    '/stock_lists',    to: 'stock_lists#index'
#  get    '/purchase_lists', to: 'purchase_lists#index'
#  get    '/sale_lists',     to: 'sale_lists#index'
#  get    '/trust_lists',    to: 'trust_lists#index'
  get    '/consign_lists',  to: 'consign_lists#index'

  resources :artworks
  resources :artwork_images
  resources :images

  resources :purchase_lists do
    collection do
      get :search
    end
  end

  resources :trust_lists do
    collection do
      get :search
    end
  end

  resources :sale_lists do
    collection do
      get :search
    end
  end

  resources :consign_lists do
    collection do
      get :search
    end
  end

  resources :payment_lists do
    collection do
      get :search
    end
  end

  resources :receipt_lists do
    collection do
      get :search
    end
  end

  resources :purchases do
    resources :artworks
  end

  resources :purchase_slips do
    collection do
      get :artworkGet
      get :priceSet
    end
  end

  resources :sale_slips do
    collection do
      get :artworkGet
      get :priceSet
    end
  end

  resources :trust_slips do
    collection do
      get :artworkGet
      get :priceSet
    end
  end

  resources :consign_slips do
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

  resources :sale_cancel_slips do
     collection do
       get :artworkGet
     end
  end

  resources :trust_return_slips do
     collection do
       get :artworkGet
     end
  end

  resources :consign_return_slips do
     collection do
       get :artworkGet
     end
  end

  resources :payment_slips do
    collection do
      get :artworkGet
      get :priceSet
    end
  end

  resources :receipt_slips do
    collection do
      get :artworkGet
      get :priceSet
    end
  end
  
end

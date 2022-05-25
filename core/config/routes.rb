Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :networks
  resources :providers

  resources :networks do 
    resources :providers
  end

  namespace :api do 
    namespace :v1 do 
      resources :networks
    end
    
    namespace :v2 do
      resources :networks
    end
  end
end

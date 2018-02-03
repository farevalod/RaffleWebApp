Rails.application.routes.draw do
  resources :tickets
  resources :books
  resources :sellers
  resources :groups
  resources :institutions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

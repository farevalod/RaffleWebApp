Rails.application.routes.draw do

  root 'main_page#show', as: 'main_page'

  controller :payment do
    get 'payment' => :new
    post 'payment' => :create
  end

  controller :admin_sessions do
    get 'login/admin' => :new
    post 'login/admin' => :create
    delete 'logout/admin' => :destroy
  end

  controller :seller_sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :admins do
    member do
      get :confirm_email
    end
  end

  resources :admins
  resources :sellers
  resources :tickets
  resources :books
  resources :groups
  resources :institutions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

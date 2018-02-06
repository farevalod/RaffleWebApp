Rails.application.routes.draw do

  resources :admins
  get 'admin_sessions/new'

  get 'admin_sessions/create'

  get 'admin_sessions/destroy'

  root 'main_page#show', as: 'main_page'

  controller :seller_sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :sellers
  resources :tickets
  resources :books
  resources :groups
  resources :institutions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/", to: "home#index"
  resources :menu_items
  resources :menus
  resources :users

  # auth
  post "/login" => "users#login", as: :login_path
  post "/signup" => "users#create", as: :signup_path

  # cart
  get "/checkout" => "carts#index"
  resources :carts

  # order
  get "/orders/pending" => "orders#pending"
  resources :orders
end

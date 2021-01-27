Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :menu_items
  resources :menus
  resources :users
  post "/login" => "users#login", as: :login_path
  post "/signup" => "users#create", as: :signup_path
end
